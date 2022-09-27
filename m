Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3015EBCB8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiI0IHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiI0IGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:06:33 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C7FCBAF7
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:00:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k3-20020a05600c1c8300b003b4fa1a85f8so4962692wms.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8KXeAi8bLl/4xDSQHTAZUIT2rxZgkHrTv7EF2KN/kpc=;
        b=xsUc6nbu4ykT7peSuwlcvmxlW8gH9JNmHu+I0twf4HwF1J5XzKYqpFWkj2dh8q5Ul6
         YIyTsCwVLcVCaqmZK0bRl0knR4E+gs1g3VmYqFhJ5ISP30EzzuG67bXySPNLETE/znCh
         1kOaxyvtrtAyp6HP8dbla4TRNZFN+GwiDeBxS7EIpqL7nzY9tGQWADkj6VBwOzLQyaFh
         pCCi4FN8EpWc+6PH6d58eIKwaMfHegUjGc14ZwZQ0iNB6osoFANcFYIfmlYevX66Nh0Q
         3cO3YAgQUZdtH3V7oCiZJtN3UhQPnMyOVOXCnj/NAIxf0w0TZI2pQe44Lv3U3z04foBx
         m6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8KXeAi8bLl/4xDSQHTAZUIT2rxZgkHrTv7EF2KN/kpc=;
        b=HRvGnQqDkQgdovJKgs6n7xxAUIKHY2Y8MR/+11QRIfy2N6qWR6sD7u385QymakUFis
         QWQhQFjl+mFIp8z3rHivzsXd5jo7M5qzQOC3+C55Ns0cLXh9fi+MNbqnWK2HXZIANV5I
         jPEZcphMBcX3TtsjLqDlVEO6HlUaIjIfJuFUEay7Iw+jrEpT7H9hDoMHpx6b+GVcQiyQ
         DpX7OS+fpBrOE023nTrE8aXf++flsyFb7tPUqJBy8bUvzNYpw3C79ifKRsTaSyf9GixR
         WsXr+DlIGUXhyXLhl2W1oZJbudIRqyz82uBq1CniR0VgB5MdFZeAEfnIzcmy7q3J3sAD
         be7A==
X-Gm-Message-State: ACrzQf1GxFyCUCKxWZVFa9vKRw2B/TKh83WMqM8EIFOfND/3Lcg2W79l
        jnDs4AGRLmcwzdSQVGQL/yl1yg==
X-Google-Smtp-Source: AMsMyM5/TzO253ei5AMvrs8QpkYUOj/Z1fLYncdDCYmb2TsApdukWwTv9OqA0R3Kzq6LByqDgxAN9A==
X-Received: by 2002:a05:600c:3d93:b0:3b4:c28f:6a2b with SMTP id bi19-20020a05600c3d9300b003b4c28f6a2bmr1627703wmb.121.1664265597319;
        Tue, 27 Sep 2022 00:59:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5546000000b00228aea99efcsm1099354wrw.14.2022.09.27.00.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:59:56 -0700 (PDT)
Date:   Tue, 27 Sep 2022 09:59:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     yhs@fb.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] headers: Remove some left-over license text
Message-ID: <YzKte9AESCrcDcWh@nanopsycho>
References: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 22, 2022 at 08:41:40PM CEST, christophe.jaillet@wanadoo.fr wrote:
>Remove some left-over from commit e2be04c7f995 ("License cleanup: add SPDX
>license identifier to uapi header files with a license")
>
>When the SPDX-License-Identifier tag has been added, the corresponding
>license text has not been removed.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
