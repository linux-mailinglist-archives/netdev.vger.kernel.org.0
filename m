Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC654BBEDE
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbiBRR70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:59:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238886AbiBRR7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A757625CC
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645207146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5oI/8dNH/4MFIeI5cLeBF2jrxGnWI8Y2my0AXgZ3EQ=;
        b=CHh1kjBhE3tKk5bgo/Eh7FzWBPHv9ppj0jk7+weXFYzzIC15fXVeP1gKPLwiMO2WsJiHBe
        asouIB2LLPymy9w/7rwiU+/vGjtdNq10GwvlyvFJZZNdc6LgGkFSYtJUMURevmy8auw758
        IFX0zrLKFzwkg4xCc8FGME/Mfoa+SYY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-INUSqEV_M_uragWZ-qRAyQ-1; Fri, 18 Feb 2022 12:59:05 -0500
X-MC-Unique: INUSqEV_M_uragWZ-qRAyQ-1
Received: by mail-ed1-f71.google.com with SMTP id m11-20020a056402430b00b00410678d119eso5914169edc.21
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:59:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=p5oI/8dNH/4MFIeI5cLeBF2jrxGnWI8Y2my0AXgZ3EQ=;
        b=yf2XdoYglh14bkUnxBz6JypAL+d1ENqYnlKxWF0HvIYIVnRDLqUUNkVHk0VLOy7WM9
         a/nd9tZxgMCr4D/JZlmKP5Z2dMAab1+RcqrlNAlZj3mFOLyOG/7lYi0FnUBXpEtib7rO
         ITe8E7Z1/87AvedopBixhkNshUIw58C36BX5HKE/KDKARIgdFOaeJ9oacG/wtHR30GxD
         3vpyh4oe9I4xRQ2w/r992yENcezf4S+suv9nasq05Uk5/bJWddLkVP5Pi2sRQzu7PaGp
         iosPHKur042NfcJTH9YQB4LCecQxTGbJ3mTSmMJPStaT+y4NaC8miWEV+ewl/yVw9dtM
         l/rw==
X-Gm-Message-State: AOAM532UldkXYnYwbeUA/CIacP+eAU9V2pSvg+FDZMvcOC4hxOUrmU5U
        3WcoGVpFebSabtsCLWX4lJf0+LzIeceOzBEvwBTUEUM3dCb1inkkMwNnl+vHX8Rt4Ikop7t2PcO
        B75DG52M8B4KfEqSB
X-Received: by 2002:a17:906:aed4:b0:6ba:6d27:ac7 with SMTP id me20-20020a170906aed400b006ba6d270ac7mr7489001ejb.33.1645207142549;
        Fri, 18 Feb 2022 09:59:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJww0cTfqnVBcid2KvnkIgltIfa8ngQGHX5cBQYZf339vsSNYU9Rk2ynmAwWH2iPxeiWIbVYBw==
X-Received: by 2002:a17:906:aed4:b0:6ba:6d27:ac7 with SMTP id me20-20020a170906aed400b006ba6d270ac7mr7488872ejb.33.1645207140118;
        Fri, 18 Feb 2022 09:59:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h7sm5077174ede.66.2022.02.18.09.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:58:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EF7B5130248; Fri, 18 Feb 2022 18:58:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 0/5] Add support for transmitting packets
 using XDP in bpf_prog_run()
In-Reply-To: <20220218175029.330224-1-toke@redhat.com>
References: <20220218175029.330224-1-toke@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Feb 2022 18:58:58 +0100
Message-ID: <87zgmo12fx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

> A sample traffic generator, which was included in previous versions of
> the series, but now moved to xdp-tools

This is still a bit rough around the edges, but for those interested, it
currently resides here:

https://github.com/xdp-project/xdp-tools/pull/169

-Toke

