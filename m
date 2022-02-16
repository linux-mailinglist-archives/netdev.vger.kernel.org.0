Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F814B92C4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiBPVDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:03:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiBPVDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:03:33 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF35219222
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 13:03:19 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so7547523pja.3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 13:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ee7X7rWpCLoEgqzTANne8aj2FCZmLn0+nAhe6f8ZmXk=;
        b=GE1tVBUL/qSDCwn9AqcsTKRr0Ch79gGj/J8EiKyTl+qb5kCYzwA2boPDdy2f0O7lVq
         I/4VsagMg8lj6a92B0kUbRGVxRTRp4+GEni9jPtNI6ksi+0Dm8oubBQggCHzJSyv72QT
         M3pHkXfRdWSPktO+vlaDCjaWXcZ5CuH5HJVYfVbNVxrLAaIrgUZo2hn722fDrc95UjGi
         cjD93JFV54hqlXrVH2PfPIOq+nM6ljwSST5upRTn8jYwBNOfAFlMSE/3myqH0qhN7Az5
         5KpRrAibauamP6vSosW95Y8LZ8/OdInW7ROXwcfzsQQ9Qo12gYNemQBd0aEdGar+DFJk
         yeRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ee7X7rWpCLoEgqzTANne8aj2FCZmLn0+nAhe6f8ZmXk=;
        b=c6MrzxM9uQY0e5+IAHOoCY/xALUQJm+sHDQw3HSSvLnfz1H7y2DrDZPhjJekqMGlwV
         sIB/25kACRVpTmx1rozaraGiYJ4ZqkG1jN5upAKQDdPu7Jk4tzzAlX+eSW7CFb2SRvrU
         87nTW1l0Md5Z4OwIj8/goHBMFbdhNfqYZkK87FKlZaqS5VC9KcjcVdjz7CrmEs+I2sNB
         BV9nbeNYOIk8XbO6L9+fWSBczxRQ9DfpZyKMPhF7NCRp/vZ2TrGNQzOsfeZsVGYTBrIc
         NXwaIzjoPcIIuiheXC4nn38WtDqzV3VhP1++FQKdRGg0wm7mx5kwHbAXHst5H2sXXN03
         A7sw==
X-Gm-Message-State: AOAM5318qO0hKcbHO4/pUZRQt/Wz2ARiJl19KnHzGQLiZspj4LBHOYAX
        2cpkNuATsMS88vruAZZB8O0w9g==
X-Google-Smtp-Source: ABdhPJxdgAZtiZvc/Eblf742C3ulQ0fcxJCcmYosbFmbYD1Och0GoRL7csy3e9JQ+H3NRoZZN+HQmA==
X-Received: by 2002:a17:902:d683:b0:14c:c0a9:34f3 with SMTP id v3-20020a170902d68300b0014cc0a934f3mr4227583ply.109.1645045399030;
        Wed, 16 Feb 2022 13:03:19 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z17sm6093115pgf.91.2022.02.16.13.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:18 -0800 (PST)
Date:   Wed, 16 Feb 2022 13:03:16 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 iproute2] lnstat: fix strdup leak in -w argument
 parsing
Message-ID: <20220216130316.40073fc3@hermes.local>
In-Reply-To: <bd64b479-9d0e-cec8-d57a-5f188a822dd9@gmail.com>
References: <bd64b479-9d0e-cec8-d57a-5f188a822dd9@gmail.com>
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

On Wed, 16 Feb 2022 23:35:43 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> 'tmp' string is copied for safe tokenizing, but it is not required after
> getting all the widths in -w option. Use strdupa instead of strdup to avoid
> explicit memory leak and to not trigger valgrind here.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
> ---
> Changes in V2:
> * Use strdupa instead of strdup/free
> 
>  misc/lnstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/misc/lnstat.c b/misc/lnstat.c
> index 98904d45..d7e1d8c9 100644
> --- a/misc/lnstat.c
> +++ b/misc/lnstat.c
> @@ -314,7 +314,7 @@ int main(int argc, char **argv)
>  			sscanf(optarg, "%u", &hdr);
>  			break;
>  		case 'w':
> -			tmp = strdup(optarg);
> +			tmp = strdupa(optarg);
>  			if (!tmp)
>  				break;
>  			i = 0;

I went with your earlier patch, just was asking.
