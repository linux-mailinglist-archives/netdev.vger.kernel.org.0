Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5946BD4ED
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCPQQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCPQQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:16:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C377CB067
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 09:16:12 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso1534263wms.4
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 09:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678983368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wX835sOTXGenDvrM9Jk5H9iGd+G5Ry9hzVMonTiqeF8=;
        b=8W0GlkXluf3WSvAkb2eCYF1ksoQ+1Ay9zcraA9kwWP4UCSDo89FkIS+UE/JTNtOr+R
         AKtVGGwXB55JlOnOqDS8UWhoXIjfn1F0XrT1FCJY9/4OYjKsobz+Xm6NxUmo8DWwNwbh
         wUOsAGtwBt8Ytz43m0FzmZZfaLPazDYjWOyo92vt15hBpmyyKrOVwRbB1iglpMhYMJSq
         l6/Aqee0FuI59mTebLgsv34/RvnB9QPfUOSgGdv/CPoCNKZnihLdPc3zKVZDmaIN+SEJ
         1SULjAWVRvZo/NcvXuTm7RKLJV3DkiNZ3nA3bXME910UCXQPgAf/0RIgMwU4wxo4/ynf
         jlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678983368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wX835sOTXGenDvrM9Jk5H9iGd+G5Ry9hzVMonTiqeF8=;
        b=yEPq8yOIgEuILe4EtA00Wq8LYQrVjloknEiTsI46QPYhOfMqyaPSNQkwYpXAMVCvJL
         3GP+rc0mQv0Nn6BNWxzVQsclk5g7Ny1ysbKK/DiMB2hKHVVcR5XC8Dv8QsUT8PbeVhC8
         62hgleb/JfUkO9U1adi8VXS752c3D/DOVDNq/SWi5Ywsr7jcENDEMpnYEtZvXoKVKATk
         5Vrtoo720sgpWRjc1MGEO7vBa1QauD33KUv7RLdDtmkNi9fhNNymROujlXbLaZ7gLcV0
         bWAKpOETn0M/MyKhVT1YzXPHWnR30As8WwYbX/kqPLvIuvpUxdC5G/6PPuyb2asUFkPE
         4Zww==
X-Gm-Message-State: AO0yUKUA4mvX1X+xDPISdKv+4WLgWjgKQS2rp5OFBQyOSnwv/JJnphws
        MTnnnjvEDBlLlHOsrDhVZUOAkA==
X-Google-Smtp-Source: AK7set/5iz9jce0skzNhfyE7OilWfOKtLGfxC9x0HFGwKgdOeFNkTmKmSTfB37p5pR3ZiYxJTEBuXw==
X-Received: by 2002:a05:600c:4f07:b0:3ed:3cec:d2ec with SMTP id l7-20020a05600c4f0700b003ed3cecd2ecmr4720861wmq.15.1678983368217;
        Thu, 16 Mar 2023 09:16:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c358300b003ed2eb5c2dcsm5734716wmq.43.2023.03.16.09.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 09:16:07 -0700 (PDT)
Date:   Thu, 16 Mar 2023 17:16:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBNAxlNhSnTxNz3z@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
>+			 struct dpll_device_ops *ops, void *priv,

ops should be const


>+			 struct device *owner)

[...]


>+
>+static int
>+__dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>+		    struct dpll_pin_ops *ops, void *priv,

ops should be const


>+		    const char *rclk_device_name)
>+{

[...]
