Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DB049E897
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244396AbiA0RMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiA0RMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:12:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE39C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:12:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id r59so3548063pjg.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h5PCZ/mn247AG0U0BehiBRmxW5sAG0qGgjg9pjGkeD0=;
        b=ulgN8kZZ0Qe4IR4nqIHEEaJ05b1MmiaJIFUpWchspzqCXvttj9uVVF26gBeC2GRrlU
         mi6nxLEhWpn29H2EZync8Mr9tFITG7HLO5AFEgZ9I4cmDxg/e7iXF+WPrGP076YWH8bv
         kStPhhYVjApnTbmTSdVvb+X3h8Ua3gp8TxOY6uk+Q4CFdDXZTIngoLvzfNjajLLV1Ts+
         tBVeUH+ZJGT3VRyz/jYZMccss3dGraGpHtMOims79MNeNWPfPmET5E0w3l0a1uJIlpOY
         IhYzHEhQUKKewTv26JiL2+QQ+1E4nDhtMgV3aB5cZZ9bK0w7VuqeAGSuCXhdM+lZxDsK
         4k3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h5PCZ/mn247AG0U0BehiBRmxW5sAG0qGgjg9pjGkeD0=;
        b=Err2sxD6upuHoPsJk7sB+r+QBzzebij+Hnqxv1tI4/alugzFbFljw+y5HydrYwvA5B
         4fjQZpiYYqoTRcOM/UMDCfylWwDkn9VJ6YRB46wBnercaA803+mj7xdaCFUpyHxooVbU
         1OUnnVWkWfH41PRAj3mnzCPKHAwW8MDfnMRcMWHNr3Uw0oERg6M2Gra7PcDZ+Dip3Q9y
         hpDH9EZasE/AXR8yRScWsVa8eCg9sK3MFZmB9Cj+fu4Ku9t144dkwpbiRcIr1DK3KM/r
         Rr8Cr1y6rLlEe40aJ9pXKeiZrR8+06Qfy4lDmE7AyiwVhCACSmqkWOCQdriysTnzf4tF
         EBLA==
X-Gm-Message-State: AOAM533IhZQug5I1UWRAOQVOqRITqJ3d4+hrECTdtoQR/5Qg7DkXlGJL
        lRJ3yMei3aXWxEpY6BFAkRgciQ==
X-Google-Smtp-Source: ABdhPJzvSoH+WqDpFPWQXQB8tgbEuK+mJthkl+pyt3IBon3tk0+f1q+R66ak4yFMR3RjK+70/ntReA==
X-Received: by 2002:a17:902:e0c9:: with SMTP id e9mr4615487pla.56.1643303543339;
        Thu, 27 Jan 2022 09:12:23 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u12sm2636054pfi.1.2022.01.27.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:12:22 -0800 (PST)
Date:   Thu, 27 Jan 2022 09:12:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH iproute2-next 1/2] ip: GTP support in ip link
Message-ID: <20220127091220.75c1863d@hermes.local>
In-Reply-To: <20220127131355.126824-2-wojciech.drewek@intel.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
        <20220127131355.126824-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 14:13:54 +0100
Wojciech Drewek <wojciech.drewek@intel.com> wrote:

> +		if (!matches(*argv, "role")) 

Matches() is a bug trap. Please use strcmp instead.
