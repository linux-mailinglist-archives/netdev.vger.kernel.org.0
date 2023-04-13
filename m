Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CF46E0F96
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjDMOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjDMOFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:05:23 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A03DA24C;
        Thu, 13 Apr 2023 07:05:18 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id oo30so907921qvb.12;
        Thu, 13 Apr 2023 07:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394717; x=1683986717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XjXD7jKfxfBFVoHv590K6/GxKkoQhn0BjJydiG8ipz0=;
        b=M7+Rbv5gZM/O5DqGCIEA58p0l/j8KurlADiTKrq/6cN9ZHEfeFqA0Cvu8BtDon1SYf
         /C0K3KyuRBIwL7fWsugHuRLrY8S+zLQetsATik8PyVr/XqUdA/NSCkWKBlInBEYforQY
         0dHckHJ9QWP+Wi4qcYbM5SapI0KyM7kTiM1th4epGy4vB2LV4YThoPKIsTTzqIvHucRl
         S02VUGTECzbA2K8hsvZ0UZigWLFYRt8JT3HddnrfRpsL4b1ac3zZN1ly8HXQ+7Xadlbt
         aoFFEhSOjDwN9aEZx5GppJHyoH1MJD1V5iAlBTCzbHE315CWMZffTs9RMbMDExG0ccvT
         gZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394717; x=1683986717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XjXD7jKfxfBFVoHv590K6/GxKkoQhn0BjJydiG8ipz0=;
        b=dNAkjOguxV/LQls+b+sKwi5iDf+xEDgMu0tQJd92LidnX1UqxZmwbmY84duK36loT4
         v4XLNgfql6jFCGHH381OAovit9PY6Osc81WQmNUGb6qmXfy48WEoJXE8Tq2Y0y8E1zLV
         0gy7YM87NZjUXyeYxTGZ/Rrc2opOF+3kmcQH338msnixNQ4YHsKNNxdrbnwuIiHfevMi
         4Korq2wHXGpOnA34vgH1rdtKTmriQ9s2S9P3UuuhQdrAY+eK8ErgzqAGZSxy6onYihQ2
         YkAc6XqQKxFr/ueyfWWwBmfyjALLLLXltJPvcxt6LsjHqUjkXvM+qQMAKrKndUmPuRzC
         U4rA==
X-Gm-Message-State: AAQBX9f16QClj8UxE0kUPGa4+whVaqqpCrLcRWUFnyevKQxVS9vj4Mn/
        K9w1UVRe8PFfbfAzcYkM80Q=
X-Google-Smtp-Source: AKy350bHrMYYHo1g9iMLRMb5ClL8AJsPvPCZohrHR75YxaWeKRpHRdgj1YdCONhBwwRbKjwG2fWUXA==
X-Received: by 2002:a05:6214:4110:b0:56e:afe2:ebca with SMTP id kc16-20020a056214411000b0056eafe2ebcamr3014532qvb.30.1681394717229;
        Thu, 13 Apr 2023 07:05:17 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ei18-20020ad45a12000000b005eac706d223sm444470qvb.124.2023.04.13.07.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 07:05:16 -0700 (PDT)
Message-ID: <427df98f-071e-8c18-3e99-45d9da944902@gmail.com>
Date:   Thu, 13 Apr 2023 07:05:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 01/16] net: dsa: qca8k: move
 qca8k_port_to_phy() to header
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Cc:     Michal Kubiak <michal.kubiak@intel.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2023 7:10 AM, Christian Marangi wrote:
> Move qca8k_port_to_phy() to qca8k header as it's useful for future
> reference in Switch LEDs module since the same logic is applied to get
> the right index of the switch port.
> Make it inline as it's simple function that just decrease the port.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
