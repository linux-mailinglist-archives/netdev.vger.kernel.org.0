Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C716D20CD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjCaMsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjCaMrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:47:48 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58420C26;
        Fri, 31 Mar 2023 05:47:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id r7-20020a17090b050700b002404be7920aso21215786pjz.5;
        Fri, 31 Mar 2023 05:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680266852; x=1682858852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OqUYhSGRw5YT8iDoGAqI3M+kGEuzH4CgDPrq5HJmMlo=;
        b=arIMMAW4UvQuLPJj9yBXalo3hYDZJ/l55bemBovJJKePIK8YAfIjqVKi5MZr4pCTU8
         EauIYm+Y1CKrJAY84rVBjjKWtN+LIr9yQGItv96OappdwVyxGCvFTRDozVBJXQSCP91j
         2WIBrNTK40wRON0H3UTDqH9rqv6FQPm1YYXArKZj27b5YXyTHbUBEXruyX9vU6b8YIS2
         iTyiZxTI51PjLumj2pKB8ZDzjoscaEg+fA0rBqnIoOg6rE1bZwb8rlt3VjDFpAnYK8MK
         FxMvSz7TUlWoKcPZ63aK1NRMaexxx7Gjf4k/7W20yg35WCDDteeyM0EOkqreGtgLfMqW
         1wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680266852; x=1682858852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqUYhSGRw5YT8iDoGAqI3M+kGEuzH4CgDPrq5HJmMlo=;
        b=sM5kkiCqUpPR/u50plo58DFlADeW8n9Eh/fc/GPp1DXfe0R519guDRmqVjREob/1dR
         bs1mi3pCuJAwaxW1zfi7QhA8AJwYzZgAyPpbPKWnS3go3mO1rx6GuLFFl03bF0i91gl9
         PoIyArdBBUi01fbnCFSbuU4U70g5JbuKOFmUF8JZJGk91MyrmYhVK+P4wCHpNi/4xjp4
         5kAnXd5WyqJf9kZMQusgIq1zHGq6sSc3PdSDTlEd4Elu87sDA2/Rta3e0/SeWhiZfSRc
         DYHhGXnPK2qRxcwI7pByIgsvnZF48DJf9djwn+vQam8nRA6dubSfLG/P64VR1fF7X7ao
         NvTg==
X-Gm-Message-State: AAQBX9eZyuMTjC5gRLAaF+A/fdQ6+Pp5OEMnI40mI20Ipf3LeWW6oJEd
        risJphxKAQKwHXWHvokDfHw=
X-Google-Smtp-Source: AKy350b2gHhbYe3CC3qYV2mkOa4IyNcZ+slnwuhriPpW/Z/TFifSZiuNwIjANjtZBL3J6VF1pKhYQA==
X-Received: by 2002:a17:902:ce92:b0:1a2:1042:cadc with SMTP id f18-20020a170902ce9200b001a21042cadcmr31686978plg.18.1680266851824;
        Fri, 31 Mar 2023 05:47:31 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:e51f:9935:aaf2:6b7? ([2600:8802:b00:4a48:e51f:9935:aaf2:6b7])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709026b8b00b001a22f9087e8sm1514508plk.51.2023.03.31.05.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 05:47:31 -0700 (PDT)
Message-ID: <97687def-aca0-b1c5-68b6-e00079613c90@gmail.com>
Date:   Fri, 31 Mar 2023 05:47:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC net-next] net: phy: introduce phy_reg_field interface
Content-Language: en-US
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/2023 5:32 AM, Radu Pirea (OSS) wrote:
> Some PHYs can be heavily modified between revisions, and the addresses of
> the registers are changed and the register fields are moved from one
> register to another.
> 
> To integrate more PHYs in the same driver with the same register fields,
> but these register fields were located in different registers at
> different offsets, I introduced the phy_reg_fied structure.
> 
> phy_reg_fied structure abstracts the register fields differences.
> 
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

You know how it goes: a framework without its user will not be accepted 
unless an user of that framework also shows up. Can you post both?
-- 
Florian
