Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32F01D5500
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgEOPqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgEOPqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:46:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8242DC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:46:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so4080328wra.7
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lPv0fJqlxQG4gprE3sO4CgLs7w2wReqSFpy/vnjEOkc=;
        b=JGDlCN/AvOkjkAJv+QuTV6Y3R2j+2rWyAL3UCNUY4B1fyYc0fQzOb39eDYZJ336wrx
         t+P7bF1Yw+0fC9YObkaz+jWNDk3b7dA+irFCOvexLz9nt3eobQ+nDvZj+WkeOhRKKuS/
         /T1EvacpQZ73o9gAto/CP3TkS8eBfJwvcLvjUrbKWxa/kvYLw1DJObO8rub0d82Hp5cN
         KTIh+MJHJPiO77/BesrSlJc0K7MFvmMp7bCDeHuc6QJb3UPr+keL1816FWtpNTPser5c
         8hxMGkr+CBxBSeUWdMZ6U1KQSuU74aDoxSCE/uskBZ77yvg92rJKe5MpZJwnKbc6wdbz
         HDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lPv0fJqlxQG4gprE3sO4CgLs7w2wReqSFpy/vnjEOkc=;
        b=tzo/yx/xGPMUd2yM5hO+PP8vXCL1rrK0jeEOebYm6wjJzK3bFkrCGIbe0qauS75HId
         24k66Flg/gmQjykGJSbAsJzmGMJiB9I7kqZF7jS3czuQRmjhTzJKGuGISGF3M2FNO73Y
         9PILlyFt2Po0N+LJZ6MvcOI/jr05pfAjlLWCuxxYM+iudFoyFnakrJkYc8aZ5rh+ek3z
         Odrmi9QiWFVnUqkKXbCH1HC4giUo0VQrbO0Kti9jFKLMQxHH9rCGr558halhh5osUe8g
         VeG3UzqllEWHGAVASMjdvTtlfqNmhJhgANe1FkVqny3H9yvt/DQN0zrJwpmvsierz1i/
         p7Vg==
X-Gm-Message-State: AOAM530j/KNrZG5IzHc+ibE+bZJrPqyCVpFx7QqhMO7gL20uu5NaSpZv
        3/KEaktmWXHnszNKAh8BgF8=
X-Google-Smtp-Source: ABdhPJwAWU2zEKbR1EC8JifD4zTyC8tBEHBL6CLV8NW0IrJPGZ8w61v1qY00UAG2jIllVrRyBTisnA==
X-Received: by 2002:a5d:6cd1:: with SMTP id c17mr4570342wrc.380.1589557578230;
        Fri, 15 May 2020 08:46:18 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v2sm4280062wrn.21.2020.05.15.08.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 08:46:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix VLAN setup
To:     DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
References: <20200515152555.6572-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <96c4f8d8-0e21-b480-644c-7df520ed0baf@gmail.com>
Date:   Fri, 15 May 2020 08:46:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515152555.6572-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2020 8:25 AM, DENG Qingfang wrote:
> Allow DSA to add VLAN entries even if VLAN filtering is disabled, so
> enabling it will not block the traffic of existent ports in the bridge
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
