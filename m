Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12F44A9EDC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377505AbiBDSVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377502AbiBDSVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:21:01 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6C5C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:21:01 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s16so5657206pgs.13
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7EbXnYpEp2ihpgKyK9nlzdcqKW4GNoPaRPH0VWrH4M=;
        b=h2UqbuvH51KrNO3TYr3i5nj01NSdyzyYaTEcowP4rLoNsuw2ZhVToLJ74CjDW1tbvc
         8ko2OqeiniHrQsRMsCykoSl1UlDYHJZXntUxGeNN9AE4igpOgoibVhBLvW4kby3AmCOO
         E02gzOfFMTkTqI26gBwvG9fto7YX2zqrl15jRNw8SZnhOJbKqi/5pymiybV3OTaozSpx
         oEoEdQZh2GnUeLCulryoMu4SrY0H/JGzH+koSpX+ZFMu0ACHb2uvruOy/7bmdyrEn4Om
         W5hdCNvHIGz+FY8aP/PJJ2Ctrfg3drcNFceDJV6kMXe/rpM3Md/Z2gjJ8lrnNow8b/uD
         PxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7EbXnYpEp2ihpgKyK9nlzdcqKW4GNoPaRPH0VWrH4M=;
        b=RfKDLbfA2wrVdrF5rQtT1TpoE3EETR8FCM2OvuR4l/ZmmB5goSfwlJnFAT6mqatgFN
         8cTmWoq/sai3+dG03sDsOYcl5UuGez94AGoYVf2UVe//thtvRqdEUUEx75QsFKPRDzIh
         FkxHVvxO04zbQxNe9bQ7hXh/ZQGU/HEOtP91Ei+4UqVD0tfMrZparTu4T1A8R+7Q49r/
         6L3IUFXp52VD34qx4ZOSP9/Zrqvpo5bqpaOauncuXO4V/1OqE7UyeEvK1FIr/TKovUAG
         tb2eEU9EMJbzmCvqHjpqk7rMnswP6nYonh0g7mvoBavF0E/5sEnIvwjuH25k99IwV8/y
         iCCw==
X-Gm-Message-State: AOAM533cwWhdXKeRXGuaHX8cP0pBMd8LPesV5BZH1B5ZNtzV4e7Lwlg1
        KhlTlfowjM5aIHseutXoRnXlYA==
X-Google-Smtp-Source: ABdhPJxbssl55hQI09h7aHckbrRr8DCxsO/r41AfT/Q58auJzw6KyLU7fs0oi++fOLDUAe9QZAXMHg==
X-Received: by 2002:a63:e302:: with SMTP id f2mr192312pgh.451.1643998861020;
        Fri, 04 Feb 2022 10:21:01 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f15sm3151367pfn.19.2022.02.04.10.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:21:00 -0800 (PST)
Date:   Fri, 4 Feb 2022 10:20:58 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH iproute2-next v2 2/2] f_flower: Implement gtp options
 support
Message-ID: <20220204102058.7f237f80@hermes.local>
In-Reply-To: <20220204165821.12104-3-wojciech.drewek@intel.com>
References: <20220204165821.12104-1-wojciech.drewek@intel.com>
        <20220204165821.12104-3-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 17:58:21 +0100
Wojciech Drewek <wojciech.drewek@intel.com> wrote:

> +static void flower_print_gtp_opts(const char *name, struct rtattr *attr,
> +				  char *strbuf)
> +{
> +	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_GTP_MAX + 1];
> +	__u8 pdu_type, qfi;
> +
> +	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_GTP_MAX, RTA_DATA(attr),
> +		     RTA_PAYLOAD(attr));
> +
> +	pdu_type = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_GTP_PDU_TYPE]);
> +	qfi = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_GTP_QFI]);
> +
> +	sprintf(strbuf, "%02x:%02x", pdu_type, qfi);
> +}

Better to use snprintf and pass length parameter.
You are ok now, but someday this might grow.
