Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095625BE611
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiITMku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiITMks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:40:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AB51DA4E;
        Tue, 20 Sep 2022 05:40:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r7so4118628wrm.2;
        Tue, 20 Sep 2022 05:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from:from:to:cc
         :subject:date;
        bh=yng4fntN3H4g/Kn8cC7l2p8l7dcWaKasoa6PW4F1QCs=;
        b=gMkDEO0GzZ51WcfNRJinNkaa0yAbv5tVus1zWKh2FtPFSBVFRfH96wPdGpZNWRUr/J
         5+Yrp+KYdJx13GE8Sg+ZrXY2cJcTREF2szhcVMsys3hK1IwZvNQwaDEzs5pNZyzPCSpB
         Qtxre4p/3Q3Ksbik/vq3ssm+Kd+z7We5eUeDXYEZAjMFbIXvsBZaQuWilmWUpXl/Gwcc
         MNwdC4LhFRGzdSfGr7uBIbBhixENzrBCF9jvQ/x/HNvy1PsQ1TmOCy03oVx6SzUFULqn
         cWuDgj9fJJw81+vthqG5oGL/aIK/rJgUOykQ2W9c5ShWkK5cXolkVHUrX+tEXcCx6Rwl
         UDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yng4fntN3H4g/Kn8cC7l2p8l7dcWaKasoa6PW4F1QCs=;
        b=dwMWbVle6m/twrmtzL7yY1z6HdE0X7vTP6TrNAHUoPXVaxqlua4kiVVoBvX2Pm5fwj
         3h5W5tGr29igNLRjirxI/sNinNL6AynVDuTW0srx72Xl2T2DW/bWZPkT8zm5SLF/S899
         EKTUGUsLjFJevGfGluqZxmbLG0EHxMGkyaAnJjqSPdXlozbQ5GxOHPTuUr5mViCkOWKz
         z/sR+OTg+tUYcNAM494iN8KErG8BhfKgVLImWahgWtvI2wuhVEATaHoj3W7LhBjpt5Yg
         A1amTW6s+PmMG8MQm56WpufhntOYt4i3YTCc1G1lXpQRCXLPw9eb+Hv+KdyX39KSSzGR
         aStg==
X-Gm-Message-State: ACrzQf3Iu606bQnkS1sGi9iE8BfMiPlAycCNHarD3sXgLGB7V5TbOoXN
        8qcJGoRabY+ux57lCzhKQgo=
X-Google-Smtp-Source: AMsMyM6hVzXP5G9oCHsivIHXufoSS54s5avthZuMy9TUis5+tymn5KOcv99zubCTgB61GHR1aZOzsA==
X-Received: by 2002:a05:6000:81c:b0:22a:38f5:1a49 with SMTP id bt28-20020a056000081c00b0022a38f51a49mr14138763wrb.454.1663677645312;
        Tue, 20 Sep 2022 05:40:45 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t17-20020a5d5351000000b00228d52b935asm1526426wrv.71.2022.09.20.05.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 05:40:44 -0700 (PDT)
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v3 net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Bagas Sanjaya <bagasdotme@gmail.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org, parav@nvidia.com,
        roid@nvidia.com, marcin.szycik@linux.intel.com
References: <20220905135557.39233-1-ecree@xilinx.com>
 <228fb86d-4239-0aa9-ba88-e3fdc7cbe99f@gmail.com>
Message-ID: <482e66b4-9dae-1376-e59a-854bfc023c59@gmail.com>
Date:   Tue, 20 Sep 2022 13:40:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <228fb86d-4239-0aa9-ba88-e3fdc7cbe99f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2022 10:29, Bagas Sanjaya wrote:
> I think by convention, footnotes should be put on bottom of the doc.

Hmm, a quick and unscientific sample of Documentation/ suggests that
 many/most existing examples put the footnote shortly after the
 reference or at the end of the section, roughly as I did here.  I
 looked at five rST files found by "grep \[#\]_" and all of them had
 the footnote body close to the reference.
The placement of the footnote text in the generated output is up to
 the stylesheet / renderer, of course.

-ed
