Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F676AAB06
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 17:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjCDQG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 11:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCDQGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 11:06:55 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FD4125AE
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 08:06:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i10so5828061plr.9
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 08:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1677946012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNRPswH7mfojPgwky25vynoh6nRPOwNiJhCydmNShSY=;
        b=e2PDO04k4zwengrP5dDVN2NczXwr/lPLCrLm+yLJ1NSN1pTVvqiC2QPeQnzB06na06
         UmWqvCRLk7Q3zRhlqU9C+8XlM5TA5ffhJy2L1ay5lh26/66JpUWhw68o14M/juuihdlt
         aKWyTVnVop3VoT97MPHepRXGuOJez2xOM19iQoRjS3GIcSBhIBv9sMaZ2M9xHWIS/lGQ
         axvEZ7GyjXkLqcHi9ucTXuFW2fv/nfH1y9R3IhahRjWa2bkJqJ+9RQVFzd2xNdeODm+f
         lvQO7+N/V59QnpGR1Ca5jKufu81iy1RT/92SPoqS/eKx/dFCmIEaDojgP9uriixxd+Zh
         oMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677946012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fNRPswH7mfojPgwky25vynoh6nRPOwNiJhCydmNShSY=;
        b=47tsFbKIECqdczV3Mpv9CQ2U/hkQ1p47OOz8YQm9t7A26Biblb74qk67zc4n+1eUXq
         g492DXj3+WnyyI8dn5mxQp0HCd940PPZkFMFVs+IHO30mNpxHeoWYKSGuzlTPWt2+vif
         g/HNsT4O5B54Sims75WlNKMc4m7NEMWpJrGbcjRLBnKk2BzTF8o53CqlzzQjHDAX/RNZ
         4gC8+qF6qkS1XaFLlMj9GaDZXJDMb07j5cV3vQwaTZ0sWUi8Ofw0K/4/KwkUYv/sxR2j
         hCZF1oBw3xquwrh854Ecrqu+YXrkEAXx4IftPF1kxQ4ZAeRaIEoCijfbhWYxOrPDGxMZ
         Rwlw==
X-Gm-Message-State: AO0yUKWydnAf/KfKLh+Kgioh3HAsWN15dzHs42nMkQXL5ij7E257Pn0x
        a+n8doG4wChZo5Jb6GizfdgFRA==
X-Google-Smtp-Source: AK7set8yIGj/nV+mQtoOzSq/HVz1BnOBETpGChwHj8gVR5WIW0N3T7PwA9bRALL9ZeYmRPJ4+Gd84g==
X-Received: by 2002:a17:90b:1b0c:b0:237:cfdb:c251 with SMTP id nu12-20020a17090b1b0c00b00237cfdbc251mr5353429pjb.16.1677946012543;
        Sat, 04 Mar 2023 08:06:52 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id gz7-20020a17090b0ec700b002349608e80csm3276373pjb.47.2023.03.04.08.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 08:06:52 -0800 (PST)
Date:   Sat, 4 Mar 2023 08:06:50 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        khc@pm.waw.pl, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v4] netdevice: use ifmap instead of plain fields
Message-ID: <20230304080650.74e8d396@hermes.local>
In-Reply-To: <20230304122432.265902-1-vincenzopalazzodev@gmail.com>
References: <20230304122432.265902-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Mar 2023 13:24:33 +0100
Vincenzo Palazzo <vincenzopalazzodev@gmail.com> wrote:

> clean the code by using the ifmap instead of plain fields,
> and avoid code duplication.
> 
> v4 with some build error that the 0 day bot found while
> compiling some drivers that I was not able to build on 
> my machine.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202303041847.nRrrz1v9-lkp@intel.com/
> Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> ---

Patching cadaver drivers is not worth it.
