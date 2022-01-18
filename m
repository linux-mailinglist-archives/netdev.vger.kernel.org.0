Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17315492F1C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348767AbiARUQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiARUQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:16:51 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE33C061574;
        Tue, 18 Jan 2022 12:16:51 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i129so341516pfe.13;
        Tue, 18 Jan 2022 12:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p9KeRmAi1sMMs7t4CVloeSIydpCU6nSKCBXHt5VNkzk=;
        b=IeVGy55mKoH8ihMhhuryTi+TcDkZN8on0Y/YFD7ggEVd+YePOmqvKGChb/Ulr4eGOC
         LCMwyAqWMSSeWTW3qOivgYkGQ6caRGVYxggShbKSdIfH8Sp3KQCWyn/TX4drLz1bHirP
         OOsS909pzLuTRh2K5C/j3iXIsxVGYH7yVdA88R6285zbIvNlv1wPboJM6u1kA6i+wTpE
         BJ9IAV7nX716viQe0RSUtgfqL5LKRZGb+FOHdHAFZJ8mMKIIhJjOvDmqWHuyw+gTuQbQ
         iVtv6UCWtOQvYYQKu1IketAqGscZSV4st3D592LzHMo5BkupXcsOO29NgYyUG+9YZ0Ly
         6veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p9KeRmAi1sMMs7t4CVloeSIydpCU6nSKCBXHt5VNkzk=;
        b=hxrFGhtaljNTMhumPu0/QArpRkeoaWCo/p0Sxm/3cwGu+OGgs3MiwBdAp2m5PN5OB1
         O6rOhaAErqbIFcS5zEaWq/V9WPliwL8vLP96bh56f9wTBXZEHnyosHTrwrKUdGVQKZBL
         6SKaGoLyTcGvmBiTZ/bYp81kW5g/NKzMWHQphTNc95ez71szNm1YV6KgWasI7q4l9ZS5
         o7Du4adt2cjZToS2NZMUrIUPgttRp7q5ey/T1r02L0FRtibtmG/h2eOL/14b9TTv4agi
         tDaq8VuMnUkEtgwJOYAPSGGizImDOOG2KDvSl51FCOJYpFI0KOvOPbTJCB60YHFUg46M
         fFpg==
X-Gm-Message-State: AOAM531YxdBvvk5GIENnoujXBvPwu5bs0n1YXNZYfw6Nw+vbtXZ0wBap
        7JibsAPS3g0O7v2kofKG0To=
X-Google-Smtp-Source: ABdhPJyQPSvoHFV1LMmpSc6wdVVEqlE5Ax1pMyC5yuBrMedXj7H3LmIUYhwsOrGJJ/0FnBqfSgzHfg==
X-Received: by 2002:a62:1681:0:b0:4bc:ceec:257c with SMTP id 123-20020a621681000000b004bcceec257cmr27937071pfw.84.1642537010601;
        Tue, 18 Jan 2022 12:16:50 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f291])
        by smtp.gmail.com with ESMTPSA id j4sm18994420pfj.217.2022.01.18.12.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:16:50 -0800 (PST)
Date:   Tue, 18 Jan 2022 12:16:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v22 bpf-next 17/23] bpf: selftests: update
 xdp_adjust_tail selftest to include multi-frags
Message-ID: <20220118201647.lwnexycnk2dq25z3@ast-mbp.dhcp.thefacebook.com>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <f7d7d5ba9c132be0dbbebe3a2e4c2377ffa05834.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7d7d5ba9c132be0dbbebe3a2e4c2377ffa05834.1642439548.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 06:28:29PM +0100, Lorenzo Bianconi wrote:
> +
> +	CHECK(err || retval != XDP_TX || size != exp_size,
> +	      "9k-10b", "err %d errno %d retval %d[%d] size %d[%u]\n",
> +	      err, errno, retval, XDP_TX, size, exp_size);
...
> +	CHECK(err || retval != XDP_TX || size != exp_size,
> +	      "9k-1p", "err %d errno %d retval %d[%d] size %d[%u]\n",
> +	      err, errno, retval, XDP_TX, size, exp_size);
...
> +	CHECK(err || retval != XDP_TX || size != exp_size,
> +	      "9k-2p", "err %d errno %d retval %d[%d] size %d[%u]\n",
> +	      err, errno, retval, XDP_TX, size, exp_size);

CHECK is deprecated.
That nit was mentioned many times. Please address it in all patches.
