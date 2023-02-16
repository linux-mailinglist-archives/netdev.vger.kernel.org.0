Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D3E6996D9
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjBPOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBPOOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:14:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5B82CC41
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676556792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iQyyCrcAoDa9nMDlTSNO31EHryQcbdbDgQyMH3QiR1c=;
        b=MZ6aTmIe9ntcPnJAu3b8WAJ0yrlnn0WK9Pnm0n2ZOlteOsZztRAY09DXu0WvkNfhSLLA7n
        t0gLLFxFmWQQvzIUQSMz6D06pGZuM/QlvqPR0nG6C4Sb7tXvu1LzSXnMrsFTJ9e3pGw6rg
        YG2/Bxe5XGeKCad5B/1Ii0aDK8/PsPU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-Kz2ikLlQOhO2Zzb1GTuczA-1; Thu, 16 Feb 2023 09:13:11 -0500
X-MC-Unique: Kz2ikLlQOhO2Zzb1GTuczA-1
Received: by mail-ed1-f72.google.com with SMTP id en20-20020a056402529400b004a26ef05c34so1688897edb.16
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iQyyCrcAoDa9nMDlTSNO31EHryQcbdbDgQyMH3QiR1c=;
        b=pKJtLk1QahSJK1fqly6VXlop2KAmT2kI8RGLT8Fjm02ZmAzV1gQ+BPYgcduVVRF1JA
         /UCMSYL5+OWEml3sXssLVci77cBeq+u8mgfDxz4zlU/S3nvXCYykGbP0ILt+lOHRBVqQ
         RevkUF44pfECByhca1zlkqwIw9G2ka8wDFj4sKYIXbO58d/7hS7SQrF8frGMY/TrWxg1
         bPosKpZj7cdHv1EbuJFMbe/6qk5q9y53UGiAlsIDYN/p38ICzs2jvssSjyFpcLDGiE7l
         zX/gLW+H4ecE/zlFIzxGQq+rINpcWnvtK2xyxFwT1j6m/9PVES7Z0IthUqbUG4VHuGL8
         6QhQ==
X-Gm-Message-State: AO0yUKUZMFk3GtaYuQrdms03oEj4SLpPER2777HLHdlpt7i2mPuc9E8g
        yu6jZEp0fTZ8XLhrUFD/fiE5ASgBwTUm4rX9lCc8oeLy5sjFPQ1QJxikrZB7JF8ixZXLaM0CZ83
        KtkrCJme6qfxAHJpqMQkDbg==
X-Received: by 2002:a17:906:1c08:b0:87b:d597:1fd5 with SMTP id k8-20020a1709061c0800b0087bd5971fd5mr6648623ejg.75.1676556789344;
        Thu, 16 Feb 2023 06:13:09 -0800 (PST)
X-Google-Smtp-Source: AK7set+b+3gudZdBL27uKxFTUYqUbYo4EY/MNLUXZgR59sohSBV711oDGlR2+MjZRoIKRL+wKt90kQ==
X-Received: by 2002:a17:906:1c08:b0:87b:d597:1fd5 with SMTP id k8-20020a1709061c0800b0087bd5971fd5mr6648583ejg.75.1676556788677;
        Thu, 16 Feb 2023 06:13:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h27-20020a170906111b00b00872c0bccab2sm857436eja.35.2023.02.16.06.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:13:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 65B99974632; Thu, 16 Feb 2023 15:13:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V1] xdp: bpf_xdp_metadata use
 NODEV for no device support
In-Reply-To: <Y+4eqeqeagWbWCMl@lincoln>
References: <167645577609.1860229.12489295285473044895.stgit@firesoul>
 <Y+z9/Wg7RZ3wJ8LZ@lincoln>
 <c9be8991-1186-ef0f-449c-f2dd5046ca02@intel.com>
 <836540e1-6f8c-cbef-5415-c9ebc55d94d6@redhat.com>
 <Y+4eqeqeagWbWCMl@lincoln>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Feb 2023 15:13:07 +0100
Message-ID: <87lekxsnpo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larysa Zaremba <larysa.zaremba@intel.com> writes:

> On Wed, Feb 15, 2023 at 06:50:10PM +0100, Jesper Dangaard Brouer wrote:
>> 
>> On 15/02/2023 18.11, Alexander Lobakin wrote:
>> > From: Zaremba, Larysa <larysa.zaremba@intel.com>
>> > Date: Wed, 15 Feb 2023 16:45:18 +0100
>> > 
>> > > On Wed, Feb 15, 2023 at 11:09:36AM +0100, Jesper Dangaard Brouer wrote:
>> > > > With our XDP-hints kfunc approach, where individual drivers overload the
>> > > > default implementation, it can be hard for API users to determine
>> > > > whether or not the current device driver have this kfunc available.
>> > > > 
>> > > > Change the default implementations to use an errno (ENODEV), that
>> > > > drivers shouldn't return, to make it possible for BPF runtime to
>> > > > determine if bpf kfunc for xdp metadata isn't implemented by driver.
>> > > 
>> > > I think it diverts ENODEV usage from its original purpose too much.
>> 
>> Can you suggest a errno that is a better fit?
>
> EOPNOTSUPP fits just fine.

An alternative to changing the return code of the default kfuncs is also
to just not have the driver functions themselves use that error code? :)

>> > > Maybe providing information in dmesg would be a better solution?
>> 
>> IMHO we really don't want to print any information in this code path, as
>> this is being executed as part of the BPF-prog. This will lead to
>> unfortunate latency issues.  Also considering the packet rates this need
>> to operate at.
>
> I meant printing messages at bpf program load time...
> When driver functions are patched-in, you have all the information you may need 
> to inform user, if the default implementation for a particular function is used 
> instead.

If you dump the byte code with bpftool (using `bpftool prog dump xlated`), the
name of the function being called will be in the output, which is also a
way to detect if the driver kfunc is being called...

-Toke

