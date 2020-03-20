Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7685518D6A8
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCTSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:17:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28756 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbgCTSRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:17:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584728270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XcqKNMIDmZgPXYKMJ/Z4y5dJuyK3gRelFg7cu60qx90=;
        b=Vly5xPipKB9SDA0XroPayMC/1+qNmnclPU8m1BCOAlCphU6+C/EVOMHUyrRJZieT6AvwJs
        J53IPU+p60x4iBVewz1AqPCzLaYrJ0UUMSN8stG8Q4xgDLJO61KfgxXaqTej7dcubYxDmS
        dzx2+3yGepthzrHLzW9Uxl06OnccUVE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-g1dQcnoVMzOal7Asdfc2QA-1; Fri, 20 Mar 2020 14:17:49 -0400
X-MC-Unique: g1dQcnoVMzOal7Asdfc2QA-1
Received: by mail-wr1-f72.google.com with SMTP id d17so2989976wrs.7
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XcqKNMIDmZgPXYKMJ/Z4y5dJuyK3gRelFg7cu60qx90=;
        b=rTBRnfjgoZH5+cbrIZPsy8UtkioMODZ2vnSWnRgFKaBSzknyk/XoFom8QA1bA6BY/y
         TS7QR9IQUSi+h0s3X1Fqn6aAJbz9C1GkRCy4jM0VrSBmUKZjWneQn7nfISKB/gGXV8Xh
         mK4uW3DOcQxp5iGcYslbJSdCh7raJk00/KdidPPUv2VaCztDSQ+nrxwaoi74AHXuTSUS
         tm7HoQLG7/DGDE/l6tJyeNUk/evATJDP9/C67lSD66rv8JuwhPThAArWmrSaoiEBkUAP
         vTkb3SRixl/xXEMA4jPfgsW9RyM436G+818liKF2AfCDnP5FjREc0NCbjR8gHJWAz81e
         qPzw==
X-Gm-Message-State: ANhLgQ0Ov75PGLJxxl45aG4LC6WRLLDfr4RibMcmRaIYLQGtMdxYxFkC
        +dsWh6PA8DuO7B8vkK0pX/czjefc7JOUX5o/QujJi2aoLp2KA1s38U1a4Hdrd6V9ssMe5MhC3Ql
        lSauUrYdn6fmz1zIE
X-Received: by 2002:a1c:23c8:: with SMTP id j191mr11848288wmj.117.1584728268086;
        Fri, 20 Mar 2020 11:17:48 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvCWblzkc0Q5TxfiBZYEQdIUHVCXwcaIu4835meoXOtk1aHCSdpgU/vbX2In/qVA8hCJEPzTw==
X-Received: by 2002:a1c:23c8:: with SMTP id j191mr11848266wmj.117.1584728267891;
        Fri, 20 Mar 2020 11:17:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w3sm3200398wrn.31.2020.03.20.11.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 11:17:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7C034180371; Fri, 20 Mar 2020 19:17:46 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 20 Mar 2020 19:17:46 +0100
Message-ID: <87imiy6gc5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

>> > If we do please run this thru checkpatch, set .strict_start_type,  
>> 
>> Will do.
>> 
>> > and make the expected fd unsigned. A negative expected fd makes no
>> > sense.  
>> 
>> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
>> flag. I guess you could argue that since we have that flag, setting a
>> negative expected_fd is not strictly needed. However, I thought it was
>> weird to have a "this is what I expect" API that did not support
>> expressing "I expect no program to be attached".
>
> I see it now, not entirely unreasonable.
>
> Why did you choose to use the FD rather than passing prog id directly?
> Is the application unlikely to have program ID?

For consistency with other APIs. Seems the pattern is generally that
userspace supplies program FDs, and the kernel returns IDs, no?

-Toke

