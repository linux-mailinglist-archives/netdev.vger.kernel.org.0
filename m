Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9971D0570
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgEMDT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:19:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB790C061A0C;
        Tue, 12 May 2020 20:19:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w65so7366898pfc.12;
        Tue, 12 May 2020 20:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Hsf3W8qDVfHj/YPXqI8QBcRpq1vh1I4Cw/366Ae27cs=;
        b=V2JdvWnL2rpZtglNA+NuCQ09DV2bWmPqP1iD4Qlg3tvwIBMweMUf3JSrIyswaqg/fX
         JH4GiJJdtIk00665T+oTY/0gTIWcUHK/GScC79x7PzOh1xA2+f82fQoenZl1AyIPdbby
         t49x3hv3qV11lyEyTkaiFPAJLOkPYZmahVd4KOB1jLvt9qKT/my5GYDWdy6Ij0lOxb8u
         PfifLJ3AyQIrHML0hKdPzfJFEz8fjjTP+UJ0K4ZYFslWc7mVcymOQfif65/WMVqlSzNq
         Xc/ViyoT/E8ZDT4sZ70PdOgWtLAqRwkV0HscStj7DfeeIFJwYcQCQ32fg75PAo8MMcjd
         LLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hsf3W8qDVfHj/YPXqI8QBcRpq1vh1I4Cw/366Ae27cs=;
        b=ZYApCKGOFnH6HFgj9Hxutlx/sy0b0hNPf3Ppls9SNe41dLsZ19qEZtfowS/7IQnneD
         fWEGxF3Qpmbiy5K/lZEqk064gWESZDaf6aJW1Zj/MfNx3yCT4G9/muqn281dZtp96/b3
         DNWnpFRRrVIuJhAIlGaoLrV56rs0D2pcpdKkABM7PgR1He4QC6K+KW0DGeoHjZZ1Mr3c
         qVlrQIoVGkMFaUAGhZSuseZsyDRk/cB2r5WDuOF1kh23ce3RZNQwhvOlsxL/ddWj74wH
         z8A/jChdNi5NhqY9oKWoRLWGKrE4H2C2gUUX2ozfC13Yw1RL426h/OpA48kuvuontUfR
         0Rgg==
X-Gm-Message-State: AGi0PuYIuHW9bZNgQa3DyqB82liseNu438gmG7R7wJe2Jb5VPJK+ertW
        xCGlp2DlXHW0amzsqg4mt60=
X-Google-Smtp-Source: APiQypLDiJn5GolQEYVt24cvuyFIDhMqg1r4pOp1Uf/gdbxJdgFP3doN5IWUJINSO3BwzDdpO8uKQw==
X-Received: by 2002:a63:ea4f:: with SMTP id l15mr21896544pgk.58.1589339996339;
        Tue, 12 May 2020 20:19:56 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k3sm2536437pjb.39.2020.05.12.20.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 20:19:55 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/3] net: dsa: felix: qos classified based on
 pcp
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        linux-devel@linux.nxdi.nxp.com
References: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
 <20200513022510.18457-2-xiaoliang.yang_1@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <94652605-329c-0f82-5fe0-b700cc40e575@gmail.com>
Date:   Tue, 12 May 2020 20:19:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513022510.18457-2-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/2020 7:25 PM, Xiaoliang Yang wrote:
> Set the default QoS Classification based on PCP and DEI of vlan tag,
> after that, frames can be Classified to different Qos based on PCP tag.
> If there is no vlan tag or vlan ignored, use port default Qos.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
