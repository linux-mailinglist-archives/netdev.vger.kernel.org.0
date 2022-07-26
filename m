Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65E4580E32
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbiGZHsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237783AbiGZHsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:48:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA7820F4B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:47:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bp15so24666324ejb.6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Bs+PrAIsG2A8FWkJ12O5ZwXKD9BEnqUwkndcxuPk/8=;
        b=PfMi/meqBcFLgiZXlwx5ZnSRo7oENvlL1XLygzVr/0/QaH8aS2HW9oqcUlaOJYLPRS
         75Y7fFKAVLeWIUQZSsUf0HVsgSnPaWQ8Ie0I59KTxV6Zk6kXoQU3QgcVMJ1NsfsWnXsC
         o8RuNDe9cIYMPGFXi9MkJNPsnSFaC+Qzy241HUJgLtd0GD/BV5kJbwRYUQCQyA8fsyxJ
         SGZ5STxStqFdeNqsji4AEFiO4PHTykwURkojb80yzxIZLjfGyxYBxVwm8KpKOCkQEDm0
         soWSPAc0TJi/NO5u8O975M7tcomlKd4DhkBGXu/gG2z21XOfw20ALPedTdu+UtXTjK/i
         Ze1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Bs+PrAIsG2A8FWkJ12O5ZwXKD9BEnqUwkndcxuPk/8=;
        b=C7eUjRLOhxqEjSj5fpkrX+9WSsBNEsOWKnZVbjultg+1cPC2DYFFdNOzufoG5owtvB
         HBhPxvjR/O1KENLI4xRgQuDmEgXLVEP9Fu3pxCVDA03sGQzwKqDUzHomqeAkiFefONk5
         odFBvdxmY5LyrO+GSjfmYgk0saFNHeDuWBNGbXZb27KSfIm2gtBLnO1pJGKiAJMRY54O
         FpUL0hZq3SiQDsbMNl+xYrMf26752KoKv/d8GXcL7Brj37oVxq3ZRNtgVFzvO8uSKHcd
         crqQbFVZYAZOWijcJqNGbIAfQ1zArfLbBeQs4rHcsUDpn1pyaFUWg0yD7pC/7xed3K8z
         t8Ew==
X-Gm-Message-State: AJIora+SjvgurQ49WzCDbKQEcJOCKzTYlJLFFK/SEWmGM7T0FSC0CDNb
        sVWvQwsGXoChdq7RHIbnfq483g==
X-Google-Smtp-Source: AGRyM1umSHz/vjdOdwc0YoU4FflWgZrw8YmYR53Ku5qXq3SjFf6CPcpknZhJi+kwL5Wk47Hykg0agA==
X-Received: by 2002:a17:907:7f05:b0:72b:5a11:b357 with SMTP id qf5-20020a1709077f0500b0072b5a11b357mr13481010ejc.67.1658821676444;
        Tue, 26 Jul 2022 00:47:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r17-20020a17090609d100b0072a881b21d8sm6156907eje.119.2022.07.26.00.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 00:47:55 -0700 (PDT)
Date:   Tue, 26 Jul 2022 09:47:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org
Subject: Re: [iproute2-next v3 3/3] devlink: add dry run attribute support to
 devlink flash
Message-ID: <Yt+cKiYYLPXEXH1G@nanopsycho>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
 <20220725205650.4018731-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725205650.4018731-4-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 25, 2022 at 10:56:50PM CEST, jacob.e.keller@intel.com wrote:
>Recent versions of the kernel support the DEVLINK_ATTR_DRY_RUN attribute
>which allows requesting a dry run of a command. A dry run is simply
>a request to validate that a command would work, without performing any
>destructive changes.
>
>The attribute is supported by the devlink flash update as a way to
>validate an update, including potentially the binary image, without
>modifying the device.
>
>Add a "dry_run" option to the command line parsing which will enable
>this attribute when requested.
>
>To avoid potential issues, only allow the attribute to be added to
>commands when the kernel recognizes it. This is important because some
>commands do not perform strict validation. If we were to add the
>attribute without this check, an old kernel may silently accept the
>command and perform an update even when dry_run was requested.
>
>Before adding the attribute, check the maximum attribute from the
>CTRL_CMD_GETFAMILY and make sure that the kernel recognizes the
>DEVLINK_ATTR_DRY_RUN attribute.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
