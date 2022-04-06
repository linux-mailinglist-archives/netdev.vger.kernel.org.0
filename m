Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600544F679C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbiDFReQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239396AbiDFReE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:34:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CEF4AE34
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 08:39:44 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p8so2786533pfh.8
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 08:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yq7GCHs06o07h5BFZ/o9wudrE4MyVe73tTx4ETbhacM=;
        b=xWBIUvzyDfe1HZ/WdToKQKxXHywLywPZQH3+LdXfamMSdgsF5OCxi3iBjqMAxPSmC4
         uChsnNjhxGRl8A97/tJXdP/TN673vH9Vt9LEBd33yFIJtnO1cZCz8yXZs+Ao5w6icfpK
         GSRYVxqpwfCL227ud/KEnAEZ/P3XEyrTAsuyPzRsazbzqZe84lTg2L+gbthgOioRHpJl
         Ys9JEp2lYuL7euceeRYzDVa9B0iQpzGR7A8B2bONusmwC+MkwBFdfldxfHjARqUUnJvp
         3UdI0Puoo31Pgrfpd8eo/maGA3dUvGCQCLKHh5Tq/dE6+ZfIRrM7ccPO0ve98xs4vXmR
         IAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yq7GCHs06o07h5BFZ/o9wudrE4MyVe73tTx4ETbhacM=;
        b=6hEADId5i7Gnmh3IyOEHVuzltMvlscfcDvJMj/GDhMm6p7cxug/NGwbDmkOdWMvVrm
         o5pQ6oJ5uWgQHmR9ud3DxBJPBddpphS2lTkPdCq+lQjWdf1UBXkJNl+tgV58K9OEWh2p
         2Cc35fsdVP0sH+rb1lCM/3rIEMExmauOmxg8HSjnshAIoZLL0cECrPxvonpmqtRmS8wj
         PqTK/STg56VxUgIKMjeEl1hXOnH21tB46KPkGHrTKEDMqqKyokzFQl25HrA9cVsscrzp
         4jFLsZAlOsQDuu1wTDbUL8btoIjcmO4kefV02XuxkJM7tWEpSJUhrdg+tZ9ZKG1IDLaV
         xBXg==
X-Gm-Message-State: AOAM5317Whc9NbS7SxiqkG7bs8jWpIKnxyt5EjCq8a+lVKEORoGUbBSK
        xtG7h93sSpjxKEKO7XBq4Z8XYg==
X-Google-Smtp-Source: ABdhPJwX+OjXrqQt2QAfYN90sWPSgjToEcw/kiFLRuCx7WK9fMsl6e7jV7rZh+qYYWU9Whwlp/9p8g==
X-Received: by 2002:a63:68c6:0:b0:380:3fbc:dfb6 with SMTP id d189-20020a6368c6000000b003803fbcdfb6mr7684436pgc.326.1649259584551;
        Wed, 06 Apr 2022 08:39:44 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id o4-20020a625a04000000b004fdf5419e41sm12366417pfb.36.2022.04.06.08.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 08:39:44 -0700 (PDT)
Date:   Wed, 6 Apr 2022 08:39:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michael Qiu <qiudayu@archeros.com>
Cc:     parav@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v2] vdpa: Add virtqueue pairs set capacity
Message-ID: <20220406083941.378626ae@hermes.local>
In-Reply-To: <1649237791-31723-1-git-send-email-qiudayu@archeros.com>
References: <1648113553-10547-1-git-send-email-08005325@163.com>
        <1649237791-31723-1-git-send-email-qiudayu@archeros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Apr 2022 05:36:31 -0400
Michael Qiu <qiudayu@archeros.com> wrote:

> 	if (tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]) {
>  		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]);
> -		print_uint(PRINT_ANY, "max_vq_pairs", "max_vq_pairs %d ",
> +		print_uint(PRINT_ANY, "max_vqp", "max_vqp %d ",
>  			     val_u16);

Good, the print should match the set parameters.

Wanted to apply but can not go against main branch, is the targeted for next
