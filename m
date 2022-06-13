Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3774D549C7F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346017AbiFMS76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347980AbiFMS7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:59:08 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE292BB31;
        Mon, 13 Jun 2022 09:14:16 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id q140so5945317pgq.6;
        Mon, 13 Jun 2022 09:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2FAhHUEQwV2Ri4EeAnAyWssQJabBhiaFgViZ1G1m5Yg=;
        b=JDA2RRUejFp891wBcOLY9StXeI4zvGKsA16FuPiujjAew+PZOn9QpGes/U3DxxBvzh
         tm9dervJ9fxe26RYEWiCBVr17fKtailAN9mZvPy+Cf4mun2VRKu8p+XLY4+bkEL2dKtW
         gbz7cEWWY/UvHeBIQkh+5Xkl4eh97bHETmGvWKCr3s72WGCkmXLZsoCZ+1fO86YWu6v9
         D1GEKAAI0CYZDpwK/N9g8q8F8mBVrzNqVdVaHrUy4UyMNqSQTmZqp+Glc5mJSXK/fovT
         53ZtqirC1+ZPyIldFtet9Q5zRKO7Cb3dYp+jxCGFJz8dVfpQbyyiwEYujed2lXLBXenR
         IboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2FAhHUEQwV2Ri4EeAnAyWssQJabBhiaFgViZ1G1m5Yg=;
        b=hjiHDua1Go2qrDkh+Lpg96hri7J0Z5Zl4D/g2DMPVNzxvVqlZ/njTMS4/QOAxpSecE
         dL7YjrwxhiNPwKIdTSWBRoZLsbfip0qVU+PIk+p+SXdKBP7ZOtyYnGjtQLz5AukzIy3Q
         j+4/hiQJ6jmwH82Z02Gk4QkmTB0arv+kw5OLqtzc7EXn605llYhhtWBHvA1/YEErgW8v
         g1ypUIsKWT64vVMuEkHV044MPzZ7b2qyYzjU4BUlcDSI5Em0fwTfQB/TlwNGatgjbSb7
         oWhHcs+kLGTeIK1W1IIfUcxPWkHjoxx9673QK4VtCKbx/XNoO0GrEma9Q8MxmzOVD4gs
         9s0w==
X-Gm-Message-State: AOAM533ZdMoapqPWm1dp/XVD4uNYtZr2wLX5Yy4wsAJBpEYBYajULTbn
        7INFXJxFTcLAb3kJZK/YCwVYqflqxEM=
X-Google-Smtp-Source: ABdhPJzFDtyW4tkARkWQmvqQDbyd8oi3KehzpkiTLMIq2ajM2QdxsHeGNurgTmd1V79DfwbU8546JA==
X-Received: by 2002:aa7:888c:0:b0:505:7832:98fc with SMTP id z12-20020aa7888c000000b00505783298fcmr348139pfe.0.1655136856257;
        Mon, 13 Jun 2022 09:14:16 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027e4d00b0015e8d4eb1b6sm5341437pln.0.2022.06.13.09.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:14:15 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:44:13 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        yhs@fb.com
Subject: Re: [PATCH v4 bpf-next 00/14] net: netfilter: add kfunc helper to
 update ct timeout
Message-ID: <20220613161413.sowe7bv3da2nuqsg@apollo.legion>
References: <cover.1653600577.git.lorenzo@kernel.org>
 <20220611201117.euqca7rgn5wydlwk@macbook-pro-3.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611201117.euqca7rgn5wydlwk@macbook-pro-3.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 12, 2022 at 01:41:17AM IST, Alexei Starovoitov wrote:
> On Thu, May 26, 2022 at 11:34:48PM +0200, Lorenzo Bianconi wrote:
> > Changes since v3:
> > - split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
> >   bpf_ct_insert_entry
> > - add verifier code to properly populate/configure ct entry
> > - improve selftests
>
> Kumar, Lorenzo,
>
> are you planning on sending v5 ?
> The patches 1-5 look good.
> Patch 6 is questionable as Florian pointed out.

Yes, it is almost there.

> What is the motivation to allow writes into ct->status?

It will only be allowed for ct from alloc function, after that ct = insert(ct)
releases old one with new read only ct. I need to recheck once again with the
code what other bits would cause problems on insert before I rework and reply.

> The selftest doesn't do that anyway.

Yes, it wasn't updated, we will do that in v5.

> Patch 7 (acquire-release pairs) is too narrow.
> The concept of a pair will not work well. There could be two acq funcs and one release.

That is already handled (you define two pairs: acq1, rel and acq2, rel).
There is also an example: bpf_ct_insert_entry -> bpf_ct_release,
bpf_xdp_ct_lookup -> ct_release.

> Please think of some other mechanism. Maybe type based? BTF?
> Or encode that info into type name? or some other way.

Hmm, ok. I kinda dislike this solution too. The other idea that comes to mind is
encapsulating nf_conn into another struct and returning pointer to that:

	struct nf_conn_alloc {
		struct nf_conn ct;
	};

	struct nf_conn_alloc *bpf_xdp_ct_alloc(...);
	struct nf_conn *bpf_ct_insert_entry(struct nf_conn_alloc *act, ...);

Then nf_conn_alloc gets a different BTF ID, and hence the type can be matched in
the prototype. Any opinions?

--
Kartikeya
