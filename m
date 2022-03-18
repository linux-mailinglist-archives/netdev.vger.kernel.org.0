Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997F24DE378
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbiCRVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiCRVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:24:48 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A395B12A8CE;
        Fri, 18 Mar 2022 14:23:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t22so8062493plo.0;
        Fri, 18 Mar 2022 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BmyQc9COAz+CFFHGIH5Z7dnLZu2up259IT/mMqyKwA=;
        b=L+vhqoATW9YNMxOqEnsdzSxNbsqE0sJ92yTz695PSy9KtO6+dsGkRYt1XIgJntG0mE
         iEitr4gpruonb+5rpsiQCZNX9Y9YS4BMt8CRJXvv4Zsk0Ci/+xv0LiZDjQEbbvLxnOIf
         YLLoSAZxJWdk+h/WV7zwC7AkYXy/jI6ByKGzgSWf82Cxm0TyT4Dqzm/v1KaiHM0H7CUm
         pIzdT8+BN2wpj0fT/me8pRMvxtohnG8xc/zOc99jGfRFyZZmqTW0cYnwbEzt9WYoCW5O
         kcqhkwiN1paM1R0ZCSNg6riNrH9DWYmJ2/KI7CgZRVUNbY9Rmw3PtpYDl8dP8jVTTv2q
         5zNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BmyQc9COAz+CFFHGIH5Z7dnLZu2up259IT/mMqyKwA=;
        b=SYvVeDVBntY6x+KjA+IOE6hZdfmwzadToLsLGYB9cS0OO9fnhZpuEcrECv6UtKY0sd
         RQkIN4xJITwB3jPO05BJJcIuZB+Ol/bcb0YvSGJDyi6YCRiqLSXJJJRfBRhKldwHliQs
         aLn14GaW8fRtNDoPlTsb/Qe/l3WKt9C2lMwIMaSb3ow8+UMP/2m42XtW8yyfBunos0Be
         LFHUhOU4RGLplx3TmxlUU+Zsi0aSfaktdk+7IdLduxnhrY7c2prpNxbpjmJ1ffKnw8wq
         egpY8OtAFeOkDxvvS865O5xtRoqTmDhmxZJMkGwPX1rudcrJ+cl0q5EAyezU77mTmuGj
         jrAg==
X-Gm-Message-State: AOAM5337itSaUldrJQITMLEIw+5TdGLP+Wbf46HdB9CuJ1Zlzb0NJovd
        vsZmGR0rqdWOiooiIRiC4LjSzDxlfAA=
X-Google-Smtp-Source: ABdhPJzMJ4LvhdpPvm99eitLoAx/cZgPwowss9OOtgPJRDgG3ZjkjNXHJkSl99/Xwqq8s9cyWfWdHw==
X-Received: by 2002:a17:90b:17c3:b0:1c6:b0ff:abf with SMTP id me3-20020a17090b17c300b001c6b0ff0abfmr5176509pjb.24.1647638608796;
        Fri, 18 Mar 2022 14:23:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ob13-20020a17090b390d00b001becfd7c6f3sm9383038pjb.27.2022.03.18.14.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 14:23:28 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Require ops be
 implemented to claim STU support
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318201321.4010543-1-tobias@waldekranz.com>
 <20220318201321.4010543-2-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b6447c89-4e72-a9b6-f731-3fefb2a835fa@gmail.com>
Date:   Fri, 18 Mar 2022 14:23:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220318201321.4010543-2-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 1:13 PM, Tobias Waldekranz wrote:
> Simply having a physical STU table in the device doesn't do us any
> good if there's no implementation of the relevant ops to access that
> table. So ensure that chips that claim STU support can also talk to
> the hardware.
> 
> This fixes an issue where chips that had a their ->info->max_sid
> set (due to their family membership), but no implementation (due to
> their chip-specific ops struct) would fail to probe.
> 
> Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> Reported-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
