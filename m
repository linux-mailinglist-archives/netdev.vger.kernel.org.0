Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988CC2A63F9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgKDMOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgKDMOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:14:31 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B41C0613D3;
        Wed,  4 Nov 2020 04:14:29 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id w13so15949583eju.13;
        Wed, 04 Nov 2020 04:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RFXZXfocAF9KTxd/RLrkHnu7gPZq2lvliYhOgLc96Tg=;
        b=Opz3FrJnQnERxqDaDOfSVwPt+AGj95cHsRtbgZWsU1yOiBbj9qAn20KTdTdBirU/qK
         hSDUPKP+zSF+jl8Tepk0sHnzIxSzvIjX+AhGtBr+H4oTji9e4PxLxbzx3pgtcHmyC6jg
         tDGjFQ8/MvGiDeblo39SREOJp5Yx2/xLgBNTu4rfnGpvgAxIXCxswG2gDR1UvkSOanjy
         t9Lc4kQPKj/of7ap/rtou6oO9qjWFw/EN4sMyaF4rscwK5UgqWypCM6PzAaBgbXp0lAN
         xidEIMViFFSrHuCl2PDNwSZpCkJa7EruhyQHyVCDuh4xOTzaIX59vcqEMmr7hds2U36y
         JhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RFXZXfocAF9KTxd/RLrkHnu7gPZq2lvliYhOgLc96Tg=;
        b=bCAsjG2dmxaF/scMUv5YTe8tQgB3iIgPYLaMlvnbSpfU/vlKXxnUSnB9ReDxT7ZGVh
         g121L3VzrMuudGlOwee3uVIVicifwVWSPfPj5JkqZQPWKYDU51EjA54RTmBUpcqupHB9
         lcpCUjT6bZQN+ecykf9ReAaIDR3Adgeb3Qc3pq6cFMMm2siBnfYClb5BHIGfuDA+MFi4
         aYibe//Xh/obufUP8RrzfVzsqH4Nh1jvXazTsqnqUxFowKXKofJijyWhbg+nurbvY9lx
         J+1iiDrpCtKkpJT+2nwMf94WRooKTZXKiTinsxPqd9Og8W5qIsX/j9zJ8E4DDmFCN0X7
         0HBQ==
X-Gm-Message-State: AOAM533a5Jx9irsj9XlQbw30XwYr9k2nNWEPJPPLy4DeMPIfgtF/h1E4
        FNW6nSljLydgFeydaQEyK4iqKX4oa74=
X-Google-Smtp-Source: ABdhPJwxGbR7Ib4PUfakWV167hZ3PGPPI7q48eY1haNdMP/mCQaH9p9Rg+XGMNtS+Vu+w+ASseSqBQ==
X-Received: by 2002:a17:907:43c6:: with SMTP id i6mr24151043ejs.207.1604492068109;
        Wed, 04 Nov 2020 04:14:28 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id y6sm976358edl.54.2020.11.04.04.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 04:14:26 -0800 (PST)
Date:   Wed, 4 Nov 2020 14:14:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201104121424.th4v6b3ucjhro5d3@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
 <20201103192226.2455-4-kabel@kernel.org>
 <20201103214712.dzwpkj6d5val6536@skbuf>
 <20201104065524.36a85743@kernel.org>
 <20201104084710.wr3eq4orjspwqvss@skbuf>
 <20201104112511.78643f6e@kernel.org>
 <20201104113545.0428f3fe@kernel.org>
 <20201104110059.whkku3zlck6spnzj@skbuf>
 <20201104121053.44fae8c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104121053.44fae8c7@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 12:10:53PM +0100, Marek Behún wrote:
> > I'm not sure it's worth the change :(
> > Let's put it another way, your diffstat has 338 insertions and 335
> > deletions. Aka you're saving 3 lines overall.
> > With this new approach that doesn't use token concatenation at all,
> > you're probably not saving anything at all.
> > Also, I'm not sure that you need to make the functions inline. The
> > compiler should be smart enough to not generate functions for
> > usb_ocp_read_byte etc. You can check with
> > "make drivers/net/usb/r8152.lst".
> 
> Vladimir, the purpose of this patch isn't to save lines, but to save us
> from always writing MCU_TYPE_USB / MCU_TYPE_PLA.
> It just transforms forms of
>   ocp_read_word(tp, MCU_TYPE_USB, idx);
>   ocp_write_dword(tp, MCU_TYPE_PLA, idx, val);
> into
>   usb_ocp_read_word(tp, idx);
>   pla_ocp_write_dword(tp, idx, val);
> 
> The fifth patch of this series saves lines by adding _modify functions,
> to transform
>   val = *_read(idx);
>   val &= ~clr;
>   val |= set;
>   *_write(idx, val);
> into
>   *_modify(idx, clr, set);
> 

So if the point isn't to save lines, then why don't you go for something
trivial?

static void ocp_modify_byte(struct r8152 *tp, u16 type, u16 index, u8 clr,
			    u8 set)
{
	u8 val = ocp_read_byte(tp, type, index);

	ocp_write_byte(tp, type, index, (val & ~clr) | set);
}

static void ocp_modify_word(struct r8152 *tp, u16 type, u16 index, u16 clr,
			    u16 set)
{
	u16 val = ocp_read_word(tp, type, index);

	ocp_write_word(tp, type, index, (val & ~clr) | set);
}

static void ocp_modify_dword(struct r8152 *tp, u16 type, u16 index, u32 clr,
			     u32 set)
{
	u32 val = ocp_read_dword(tp, type, index);

	ocp_write_dword(tp, type, index, (val & ~clr) | set);
}

#define pla_ocp_read_byte(tp, index)				\
	ocp_read_byte(tp, MCU_TYPE_PLA, index)
#define pla_ocp_write_byte(tp, index, data)			\
	ocp_write_byte(tp, MCU_TYPE_PLA, index, data)
#define pla_ocp_modify_byte(tp, index, clr, set)		\
	ocp_modify_byte(tp, MCU_TYPE_PLA, index, clr, set)
#define pla_ocp_read_word(tp, index)				\
	ocp_read_word(tp, MCU_TYPE_PLA, index)
#define pla_ocp_write_word(tp, index, data)			\
	ocp_write_word(tp, MCU_TYPE_PLA, index, data)
#define pla_ocp_modify_word(tp, index, clr, set)		\
	ocp_modify_word(tp, MCU_TYPE_PLA, index, clr, set)
#define pla_ocp_read_dword(tp, index)				\
	ocp_read_dword(tp, MCU_TYPE_PLA, index)
#define pla_ocp_write_dword(tp, index, data)			\
	ocp_write_dword(tp, MCU_TYPE_PLA, index, data)
#define pla_ocp_modify_dword(tp, index, clr, set)		\
	ocp_modify_dword(tp, MCU_TYPE_PLA, index, clr, set)

#define usb_ocp_read_byte(tp, index)				\
	ocp_read_byte(tp, MCU_TYPE_USB, index)
#define usb_ocp_write_byte(tp, index, data)			\
	ocp_write_byte(tp, MCU_TYPE_USB, index, data)
#define usb_ocp_modify_byte(tp, index, clr, set)		\
	ocp_modify_byte(tp, MCU_TYPE_USB, index, clr, set)
#define usb_ocp_read_word(tp, index)				\
	ocp_read_word(tp, MCU_TYPE_USB, index)
#define usb_ocp_write_word(tp, index, data)			\
	ocp_write_word(tp, MCU_TYPE_USB, index, data)
#define usb_ocp_modify_word(tp, index, clr, set)		\
	ocp_modify_word(tp, MCU_TYPE_USB, index, clr, set)
#define usb_ocp_read_dword(tp, index)				\
	ocp_read_dword(tp, MCU_TYPE_USB, index)
#define usb_ocp_write_dword(tp, index, data)			\
	ocp_write_dword(tp, MCU_TYPE_USB, index, data)
#define usb_ocp_modify_dword(tp, index, clr, set)		\
	ocp_modify_dword(tp, MCU_TYPE_USB, index, clr, set)

To my eyes this is easier to digest.

That is, unless you want to go for function pointers and have separate
structures for PLA and USB...
