Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216B4647FBC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiLIJBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLIJBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:01:19 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6A26AA8
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:01:16 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id t17so10017259eju.1
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 01:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7r/p52z3rraaXKdt3yxbWGkrklyO1CuvC2km7HS31WQ=;
        b=BsXH5AnAwI81PZvi2GwUE1RPRFgwMjpxrH6CdZr2Cgvo5q9vJflP4tE0W4RAH5o/O+
         HBiak3XRoOQk5hPQcxZDK2L6WmR1U7693ZMJlKCCRFoJ2/qoERBMZRqIjBpoOW2g5T9g
         /Fv3BAe9cLNjGs+WaGNM86Dsg5mfdfUNDWZzsCQNm/6aDJqs8OBtTxNTTADLZ4GdVTym
         D9uqJSXVsxmkxGbXYv+kY1XTV8IecJHDjrPuknylxT1NfKVG6CsOJ5/ShpsW7LwcKjes
         0SyUMWhGxCUxMWsgS1r5PquZ/hSTyivj4HKzEu5KFIpTTOMZjDfIWcCtfmvurgsgd9r+
         ul8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7r/p52z3rraaXKdt3yxbWGkrklyO1CuvC2km7HS31WQ=;
        b=5MN8AxfKJaZlWEUbV1qAYhx1vVl6yiI5+/rEYhg8vHvvT6O/OkUuKluPmcrqqEItEw
         JSZD1bWkCvR76KqzBiuhPjt7v4jOv8OWgDMU5zda3l59BfKBPLnIJsiPxXhICQs8OQNP
         PdPsu+LmitMqpVTQ7kPUczph6doMosGQE2vUnN42i1OX/SgPd2LalO0htBMaH4KATzSk
         fwvJZMgOr4OpoXb/0VedckMrJ5jd1xyKHQ/m5BcZ6f4LE7b9eiEdX6GRbzGv34Jnwfa6
         IoacR7fUiNieLI2szgMFxRePBZWk2w7pnN7d4eVbJ0vPgyUtcJ2J9SuI7YkyqCrmAt/F
         vz1g==
X-Gm-Message-State: ANoB5pk7Evz2VVJMf2crGfvEPahwCoA7BFujNQ8s2oYQo+uwl9UcwOhd
        1S4kp6yNBiIJjjnGl6m7pgupnw==
X-Google-Smtp-Source: AA0mqf7RXi3C5amjgVhc5Giq1i9ydnu2dOuV4JC1BDcWnHt+EPCHbL6JsURoIJnXF2gZ9Pv1YIz0gg==
X-Received: by 2002:a17:907:208d:b0:7c0:fe60:be12 with SMTP id pv13-20020a170907208d00b007c0fe60be12mr4251455ejb.25.1670576475322;
        Fri, 09 Dec 2022 01:01:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fu38-20020a170907b02600b007ae32daf4b9sm317942ejc.106.2022.12.09.01.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 01:01:14 -0800 (PST)
Date:   Fri, 9 Dec 2022 10:01:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     yang.yang29@zte.com.cn
Cc:     salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brianvv@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH net-next v2] hns: use strscpy() to instead of strncpy()
Message-ID: <Y5L5WafWuHlqKHoa@nanopsycho>
References: <202212091533253334827@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212091533253334827@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 08:33:25AM CET, yang.yang29@zte.com.cn wrote:
>From: Xu Panda <xu.panda@zte.com.cn>
>
>The implementation of strscpy() is more robust and safer.
>That's now the recommended way to copy NUL terminated strings.
>
>Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
>Signed-off-by: Yang Yang <yang.yang29@zte.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
