Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0635182
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfFDU6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:58:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36783 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfFDU6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:58:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so3651768pgb.3;
        Tue, 04 Jun 2019 13:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jU6FCdbmVH25cMl/Qsrg2wb7Hc352jmBOfOPp6LTdmI=;
        b=E8uaauFKmiHlCMOswFL03QRgZYM2sXYQsHTtMiX9Wfx6Rwz2Mr4GLkrW3ngpezfNts
         vq8BDh4fkYHoTyh9i0IcYmqvHmAfRuMYB3p0M9tga9dWXbQQgEeS+v9i77Nl6a9YaCOr
         hFUExwlLyySszQIN4gaYrotPp0DdHmtY8SE1l0K6N2XCB7SqicxRhthsw1wwgtBSEkTI
         H81SzIPcAzmNxery7iGq9VVDEhCghFsZhXmIH3JP9LiV4cEEulnAUchF13hpbPtDAd6u
         WFOMtDlSYFz3QAP5aGP8a0oNIUgr8Nfxzw2mtqL3zdeMacUScOck7Ar6Jy91mnTxcnGU
         IwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jU6FCdbmVH25cMl/Qsrg2wb7Hc352jmBOfOPp6LTdmI=;
        b=buyJA+QHCg90IhF4XigrHir0YBUiiBPLN5VPfdEHNR4+QMw+ZRA0xayTuuOHBKojwi
         VZ6yKENd46BRHw51dqBuImMAhZyGFEJK92FaT5vhc/8s51+7hPc4k9WQjiEG4cnZpj0p
         nJ8wgxA+JIFArSzG59X+6LtbmfhLnv2GmoPxf1HY3ZP/7oXVTfCG7X/YeErn3B2xpqKe
         290n2eUYUrazMclS/UC3451/tEbPxtsdrAXzAYW8lXmSQ+Naz4WHnbvUh+b/1vIqfNhS
         HcLa6w2xLtoDV0jiwtViYnWXcXPoNDWMqaiVhJuJ6jgjg12koUJXhuvPV5KRkWY19Gri
         Nh3A==
X-Gm-Message-State: APjAAAVVdjS8yrrLJ4yhutdpbq+2ZTNdR0tMkIujAz1ju+agqXwgAoL2
        Nzasu7ykPb46spwSFfOXuYS5ToLJ
X-Google-Smtp-Source: APXvYqwnLTC0pcBq0l3nuM3ilLst6xsUAtObSzzO/XGbx51JYoODK9jAMcO2zRxZrjgVkpLuaYCvgg==
X-Received: by 2002:aa7:8e46:: with SMTP id d6mr40716895pfr.91.1559681894225;
        Tue, 04 Jun 2019 13:58:14 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id z4sm18628064pfa.142.2019.06.04.13.58.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:58:13 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 04/17] net: dsa: sja1105: Move
 sja1105_change_tpid into sja1105_vlan_filtering
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604170756.14338-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <31e5c5ab-7188-2ebb-d090-3e31f737adf5@gmail.com>
Date:   Tue, 4 Jun 2019 13:58:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604170756.14338-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 10:07 AM, Vladimir Oltean wrote:
> This is a cosmetic patch, pre-cursor to making another change to the
> General Parameters Table (incl_srcpt) which does not logically pertain
> to the sja1105_change_tpid function name, but not putting it there would
> otherwise create a need of resetting the switch twice.
> 
> So simply move the existing code into the .port_vlan_filtering callback,
> where the incl_srcpt change will be added as well.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
