Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8268763E42B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiK3XCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 18:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiK3XCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:02:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B49C5AE1A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 15:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669849268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtPoW3uGxrDpE4M8rJV3W7KqyYEeMHbReVLlNL7JOzU=;
        b=A90l80Ion9wwLBctAoJ0qRx/W1ahvD5lB6McaEt97SAykVU5fV6833LcLA5dLzxtXP+k/j
        r5/5ftAbW9M62zvETJKWhavmqTVF95KWWHHWCKRrAeVpCLqvrEfAafQO8YeHqU5dwxwFhi
        VBTk+a7fnz43INefjSnrEPIQ1c/PfVk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-183-I66WGKx7M4-fFFZmYRfFjw-1; Wed, 30 Nov 2022 18:01:07 -0500
X-MC-Unique: I66WGKx7M4-fFFZmYRfFjw-1
Received: by mail-ed1-f71.google.com with SMTP id c9-20020a05640227c900b00463de74bc15so20747ede.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 15:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WtPoW3uGxrDpE4M8rJV3W7KqyYEeMHbReVLlNL7JOzU=;
        b=793t4WXpAv+YRAygahlpuBmBDgsttEHSQ0HXePfh3LP8vNg4wBI+eM4Ls4EMKtW6Ob
         PCMFvdzBuw62yNbqjjN7H9qB1L1G6/jeJoLAIFkK+0LHQQxV2Tyq52yLLvs3hY4QdVYJ
         QvrzV5V0CI8hpjlOO04Gyz3IV6AaX3+pxFHYz2P5N6XIEJHwj80R6HVT8sqFxg0bVAD8
         zM+a7sManRMWKZF15oJEwOhtO3RM3a84ieZG0TyWULukKgDnA/s2m8hrpto51G7vltHD
         e81xCYCA9QTKkNZtEcwuIdT4NbAmO+EALv9ZOox5fmhFsCeShKIK5/rdOYCWXItSNhRz
         x3cg==
X-Gm-Message-State: ANoB5plitvZYWJyYtDyhF5n6DXeRL0Kt/83TfYuTEyRgRdFoum8j5Tra
        y+Ais5clEPlpK4ODG3WnX6QyWLqtr49rmoWDMYHfmaC6jEvlV5pTc86a0AMu53A/dGdKOkdtbnV
        TunmtQeUb+RT5sfYa
X-Received: by 2002:aa7:c690:0:b0:46a:e2b8:1be9 with SMTP id n16-20020aa7c690000000b0046ae2b81be9mr21743361edq.182.1669849263491;
        Wed, 30 Nov 2022 15:01:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Pc+jVN4AQZ2o6WxZy7QkFFj3Om63BsCTurb6PVOF/KZQtd5aZyoH2jGxdINcJJODRqBRQ4w==
X-Received: by 2002:aa7:c690:0:b0:46a:e2b8:1be9 with SMTP id n16-20020aa7c690000000b0046ae2b81be9mr21743294edq.182.1669849262349;
        Wed, 30 Nov 2022 15:01:02 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g18-20020a17090604d200b0078d9b967962sm1099598eja.65.2022.11.30.15.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:01:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D688480AE89; Thu,  1 Dec 2022 00:01:00 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
In-Reply-To: <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com>
References: <20221129193452.3448944-1-sdf@google.com>
 <8735a1zdrt.fsf@toke.dk>
 <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 01 Dec 2022 00:01:00 +0100
Message-ID: <87o7soxd1v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Tue, Nov 29, 2022 at 12:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > Please see the first patch in the series for the overall
>> > design and use-cases.
>> >
>> > Changes since v2:
>> >
>> > - Rework bpf_prog_aux->xdp_netdev refcnt (Martin)
>> >
>> >   Switched to dropping the count early, after loading / verification is
>> >   done. At attach time, the pointer value is used only for comparing
>> >   the actual netdev at attach vs netdev at load.
>>
>> So if we're not holding the netdev reference, we'll end up with a BPF
>> program with hard-coded CALL instructions calling into a module that
>> could potentially be unloaded while that BPF program is still alive,
>> right?
>>
>> I suppose that since we're checking that the attach iface is the same
>> that the program should not be able to run after the module is unloaded,
>> but it still seems a bit iffy. And we should definitely block
>> BPF_PROG_RUN invocations of programs with a netdev set (but we should do
>> that anyway).
>
> Ugh, good point about BPF_PROG_RUN, seems like it should be blocked
> regardless of the locking scheme though, right?
> Since our mlx4/mlx5 changes expect something after the xdp_buff, we
> can't use those per-netdev programs with our generic
> bpf_prog_test_run_xdp...

Yup, I think we should just block it for now; maybe it can be enabled
later if it turns out to be useful (and we find a way to resolve the
kfuncs for this case).

Also, speaking of things we need to disable, tail calls is another one.
And for freplace program attachment we need to add a check that the
target interfaces match as well.

>> >   (potentially can be a problem if the same slub slot is reused
>> >   for another netdev later on?)
>>
>> Yeah, this would be bad as well, obviously. I guess this could happen?
>
> Not sure, that's why I'm raising it here to see what others think :-)
> Seems like this has to be actively exploited to happen? (and it's a
> privileged operation)
>
> Alternatively, we can go back to the original version where the prog
> holds the device.
> Matin mentioned in the previous version that if we were to hold a
> netdev refcnt, we'd have to drop it also from unregister_netdevice.

Yeah; I guess we could keep a list of "bound" XDP programs in struct
net_device and clear each one on unregister? Also, bear in mind that the
"unregister" callback is also called when a netdev moves between
namespaces; which is probably not what we want in this case?

> It feels like beyond that extra dev_put, we'd need to reset our
> aux->xdp_netdev and/or add some flag or something else to indicate
> that this bpf program is "orphaned" and can't be attached anywhere
> anymore (since the device is gone; netdev_run_todo should free the
> netdev it seems).

You could add a flag, and change the check to:

+		if (new_prog->aux->xdp_has_netdev &&
+		    new_prog->aux->xdp_netdev !=3D dev) {
+			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
+			return -EINVAL;
+		}

That way the check will always fail if xdp_netdev is reset to NULL
(while keeping the flag) on dereg?

> That should address this potential issue with reusing the same addr
> for another netdev, but is a bit more complicated code-wise.
> Thoughts?

I'd be in favour of adding this tracking; I worry that we'll end up with
some very subtle and hard-to-debug bugs if we somehow do end up
executing the wrong kfuncs...

-Toke

