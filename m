Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56D065EE05
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjAEN5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjAEN4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:56:52 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A2F4A962
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 05:55:46 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b2so39392899pld.7
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 05:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p03/YU7g6KLx1jYCV3GHh1AiNf6bblORPbTLaCJlWuU=;
        b=0/7w7MBKs5pwT4M3OShwcHlZIEsaXVDyOy9oeKBJVP/QsDYmOmeqcv1+tB/1iHNzpL
         S7VJNIvHjMEbTk0jfIgrA32JgFPVEU8hka0w2EdtyAmhSS0APfo+9DrqIWLI3+eD5FmT
         qEAFx00hFdLEQzYQHHkGqRJuJ3F875hqOXJCkL/qeXMhcAPImgdnWhTO1Bz5UFzhOC/I
         8bQmToqp5rnDMALMDufooMCoM9si21c8Hd7AfkJUd8Khw/i7AKRXPGFS2lB/ciP8kCRc
         FrCFFzJBFTnEcQGn+E7st9VDxu6iMYQpg0y3mAd/gCd+Rpls+fzPgbbQlw8xyhP1G9CO
         6DBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p03/YU7g6KLx1jYCV3GHh1AiNf6bblORPbTLaCJlWuU=;
        b=VSn6YbKjnLYhv841DXkyCOgDm22S0UQchrOqKNEGHeLm4HQnHV0FQ26KPrha33ohz9
         ca5zC2ospp1n9XQOdSBFe8//1Vvgv6s10Tf6n8FnY9P2yImVXmuNsGfopaR8NKiAbnEz
         V5MZst7J+5MI+4CVHIqzbP18C8lww1zZt2TYH4DrsFBj/vT7AJxFyXCygyzHvf0Few0c
         43kJujvcV74xQ2DjZB4l+mGvTLrcWeu5DhItxRwITX5FY9U5V47qM8O7PUlllfnqwWQb
         YMI9JkT0hUEaK7F02Y9jsdJtF4BJNuwayJ3Z4Xfg7v0pnXcfYCQJS5vrQ9EssgF9o1yu
         m14w==
X-Gm-Message-State: AFqh2koTVnB4yA6CwjTqxLAXHvqs+GHYk7PHt2O1ImXjNvlW54MUnwk1
        7f4GWlkBxjuoZfgw1+Pvp0Mudw==
X-Google-Smtp-Source: AMrXdXtguNXNXhoTjEIMLnkgDvdakrVgtxhGLhciQxi3wgXRfF1DEMLcgzYY31toM37aYcgS61b0Hg==
X-Received: by 2002:a17:902:7fc2:b0:192:e2bb:c98e with SMTP id t2-20020a1709027fc200b00192e2bbc98emr7570818plb.6.1672926945534;
        Thu, 05 Jan 2023 05:55:45 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id k24-20020a63f018000000b00478fbfd5276sm21701532pgh.15.2023.01.05.05.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 05:55:44 -0800 (PST)
Date:   Thu, 5 Jan 2023 14:55:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sameo@linux.intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] NFC: netlink: put device in nfc_genl_se_io()
Message-ID: <Y7bW3XwUzcrfqBFc@nanopsycho>
References: <20230105082738.671183-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105082738.671183-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 09:27:38AM CET, shaozhengchao@huawei.com wrote:
>When nfc_genl_se_io() function is called, no matter it failed or succeed,
>it does not put device. Fix it.
>
>Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
>Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
