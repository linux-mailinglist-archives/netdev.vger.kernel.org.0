Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF05E547AF7
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 18:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiFLQK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 12:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFLQKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 12:10:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB412496B9
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 09:10:22 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o17so3187343pla.6
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 09:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oR0dnZK6nrRMS6ZDhD3LwxLEHaWUDoCGatr2xd2YdHo=;
        b=ElHXQY7ziCl/MC1s8xB81LGI7zSWbrM6YAjuZGfqZfEqp+9p9sHvJXj7iC3ibSoUDL
         KgleECAAINh/ee2+JWZEoapRaLwNmtRq75PZ9YMgSjASuGF8i2y0IjYkFNFycxiRywHf
         TwcwpzZJqd5fEPSOibEYEtk4IpaQ/klmphw0AC328g22DdCQfFaYrqNFGUCLbrBwkEr/
         wrC6hT0MLf6KGl6iX4t2MgZQoOSFH547CMCsSlsP7gCddDOyLFrhOS7FYJE2C3HNOe6/
         v4SqGFMU1ZmtF2XgHKTSkvsovLpk55LTBa2gKhIssAUO9aoCO7F7oLlP40OdUumO6kBe
         7W/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oR0dnZK6nrRMS6ZDhD3LwxLEHaWUDoCGatr2xd2YdHo=;
        b=6z+rcHBeCvXXHLn3ar8wF/HHktdSt/rX30c8dbd7yX8h0EPZaoK7U0z7leDczuhtZH
         EdMrh0S6SFCIlbO6AjXWZcTHC9Ta4tJvqBB8hA96CFOZCHmGs9jBTlJzAUDWBYvX+bQe
         Oj/rgHq2DeYqe/hUeLukClxWj1mmXrYV/qMWuFpazQ6Zc108Hmp9jR61Ig+bY3tBjPQQ
         Zep3TjsbkzFt4jzfSBYKlKGeE4BMzbfCfoZzigQuK0bWu5JXp5MXMImFZCSL+zgbnfsv
         uCslTURcI3+6scg+pzA/UO7T7n/BOttIC+J/LqATywdqtCPmoVhCnqYtsg5k9DmGJPOO
         qV7w==
X-Gm-Message-State: AOAM530/t0YYcExN3yjfMboI8fbMpse26o6493Y65az0HSBtpfKmgxE5
        kwY8W+PF/AhauO/gNQZubphKCd2aRFaI8lWh
X-Google-Smtp-Source: ABdhPJz+6UI5XfnLM9PbYhq0V7cA2pj8uxFAoggZl0VOhs+ttGWrI+WLXwK+lReSsrdcaIpaytdfxw==
X-Received: by 2002:a17:902:bb90:b0:163:ad4c:624b with SMTP id m16-20020a170902bb9000b00163ad4c624bmr53972381pls.87.1655050222152;
        Sun, 12 Jun 2022 09:10:22 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id t23-20020a17090aae1700b001cb6527ca39sm5490595pjq.0.2022.06.12.09.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 09:10:21 -0700 (PDT)
Date:   Sun, 12 Jun 2022 09:10:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [iproute2-next v1] seg6: add support for flavors in SRv6 End*
 behaviors
Message-ID: <20220612091019.6223bf9a@hermes.local>
In-Reply-To: <20220611110645.29434-1-paolo.lungaroni@uniroma2.it>
References: <20220611110645.29434-1-paolo.lungaroni@uniroma2.it>
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

On Sat, 11 Jun 2022 13:06:45 +0200
Paolo Lungaroni <paolo.lungaroni@uniroma2.it> wrote:

> +	strlcpy(wbuf, buf, SEG6_LOCAL_FLV_BUF_SIZE);
> +	wbuf[SEG6_LOCAL_FLV_BUF_SIZE - 1] = 0;
> +
> +	if (strlen(wbuf) == 0)
> +		return -1;

If you use strdupa() then you don't have to worry about buffer sizes.

+			else {
+				if (fnumber++ == 0)
+					fprintf(fp, "%s", flv_name);
+				else
+					fprintf(fp, ",%s", flv_name);
+			}

Minor nits. I am trying to get rid of use of passing fp around
and just use print_string() everywhere. That way can do quick scan
for places still using 'fprintf(fp' as indicator of old code
that was never updated to use JSON.

Also, it looks the output of multiple flavors does not match
the input command line for multiple flavors.
