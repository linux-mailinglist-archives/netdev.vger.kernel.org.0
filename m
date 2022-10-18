Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421F8602E20
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiJROQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJROQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:16:58 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1093DBCB81
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:16:58 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v11so788848wmd.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=khumNE/9NHSamDPPsziQSRB7o6Qre+1OtoK84grTRmE=;
        b=73hNzB3lqfl/PtpFdd8GCqYvz2JmbpfbKjHQLvcHBSUa/YX7yAbVz2nt7ky4MCL0b+
         dLTIgsA4buyrbhdzMKs6Xgc/SuwlgNq0bmHTmHWyLxPFxSamUZnUAOn+woyg7uArTggu
         5sBe9Aw0hMYhTKBzuu0PzQQ3O2vJpC4PkovUTIeOQe50ReyTkLbj17oMMeki+9IUkwvt
         IOXSTlfMAYrS4jYoUACjOCGc1lV/byLsNb+Ctv4M7JVAARJHWwExtJxXld68DWX53HPh
         mbZs6QFvtgdKk37oEwDiJz4ZAEkPnTWkVo6PgIeuGY2uJsWF+LAhpHWizxAP/C8+F1gW
         f6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=khumNE/9NHSamDPPsziQSRB7o6Qre+1OtoK84grTRmE=;
        b=gemyfES48Ux5CUYqBtZ53mjpihuyN84GRhaaOGSPqIUbtEfZdsGouoOOH1ImQDG4Se
         PeBX3SeCLswK8FTlg9p7PwcKd75crcth7xh2gAny4045ZYI/h43JabgBJbaNglepKwvr
         Xvws0PYYsk2m6lhDxKUN2yM3ZQjgtelpjY7vCHNRsrjTQ3HrPVnmVyfik1xbe0GXakSi
         ay9PzUZxUXjOv/anZFYM/92JUmdEkoMO67Ia0akQHUpD7xgGrPHfLaoGxb31GuxgP2e6
         eTEhq18Z0VRFJmSl5uLK2oMnz3fS8FADjGsqD1fSb4W/EAKNd+z+5L/SI1RxKQmXbYBj
         Ps/w==
X-Gm-Message-State: ACrzQf35q+ZsaKS0vFjkhclurkysyhrk285Hj/ejuLojVPfLjEsAj1sc
        7t9MSt82haAspHGL55BqEijGsQ==
X-Google-Smtp-Source: AMsMyM77HUta1fdRT0VWzllxASbS0ekqc/OWeMk2eB2qG/+QsSBKlZv6aRn41kGumxLErObC/zEFYg==
X-Received: by 2002:a05:600c:4f90:b0:3c6:c7dd:ce40 with SMTP id n16-20020a05600c4f9000b003c6c7ddce40mr20076485wmq.114.1666102616476;
        Tue, 18 Oct 2022 07:16:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t9-20020a05600c198900b003b4fe03c881sm19676590wmq.48.2022.10.18.07.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:16:55 -0700 (PDT)
Date:   Tue, 18 Oct 2022 16:16:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v6 0/4] Implement devlink-rate API and extend it
Message-ID: <Y061VtBGHOaDK3y5@nanopsycho>
References: <20221018123543.1210217-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018123543.1210217-1-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 18, 2022 at 02:35:38PM CEST, michal.wilczynski@intel.com wrote:
>This is a follow up on:
>https://lore.kernel.org/netdev/20220915134239.1935604-1-michal.wilczynski@intel.com/
>
>This patch series implements devlink-rate for ice driver. Unfortunately
>current API isn't flexible enough for our use case, so there is a need to
>extend it. Some functions have been introduced to enable the driver to
>export current Tx scheduling configuration.

This is not enough to be said in the cover letter. You need to clearly
explain the motivation, what is the problem you are trying to solve and
describe the solution. Also, provide example commands and outputs here.

