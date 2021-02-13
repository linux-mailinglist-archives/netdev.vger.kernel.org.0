Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC46831ADD7
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBMT7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhBMT7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:59:37 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688A8C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:58:57 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n201so2798523iod.12
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6Mwqj/785bUm3Y0+03ZETSNFdoAjg6V/3edPTJngSYs=;
        b=QiOUsvhMMU1hkeF805Pibfrrqj68X4hdSaQ4gG/S0yGWb7Dh7IEDw9dd/FiiiGfoFa
         +vnF/c3JJaj3TQ54/ZQBORCnEypfT6AGncYpCVy87GriIx2/cmBWucmoAGSplDzFgKEO
         j43mLDnY92QBhn4PR0KhMSJDpaua3vfolRYERg8TnLO+thx46pl8o6tW3btvDb95rNya
         EZ7ouzlpccRS2q7tEn7Jm8nRKyQsCcJj8hN1hj43QEY5oA/ErZpVgDBCLaqc/jhByaiN
         Zaw1LGX44ZaY2zsY7adaQDg04C/UhmQYlaFA24HVad4nJe6vj4py6+gu7v3BPEUT651l
         uDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Mwqj/785bUm3Y0+03ZETSNFdoAjg6V/3edPTJngSYs=;
        b=tS9C/JdPkcmbKpBNGjUIfWMg4ONbF5kpSqTQjbG5YrCitTB7ZPWusuO/JVNAH4ZI4d
         vxG8x8dbfpwDK4Cv1TaDLA6nztEz2aO3wGpk64iRxwIBt73Rbv8TArPa8iHyofnqAyel
         Avv1vOiG8j/bOc7b8G80tWRT5n8ApQYgOceJe/PLElcEX9KOCOOjKsUeTtXBqXa3x2T7
         RBdotbXET/hRR3n/fk/NoOTB7ZoT+P9AJmQhF7hkWHPFl3wJ0D06VypmrdCuAiqD/6KI
         6Xt8kR6hLSdWirxXNHgXx1IcFG5Nk5Ws57egfI1viRZduKg3h7U0xqyTgSHCEl4kakwH
         mdng==
X-Gm-Message-State: AOAM532SfRR391ivtHQsA3q0pXMKT/HhVN99wM4FZrCUCEUdTqvW86Ay
        wsCUb7fUOHtsy2UzPVEI9Ac=
X-Google-Smtp-Source: ABdhPJy8hqVgTTCJyuwUXFaT3Ooj/JFpmbhWZTijhqW3vcU/0clk1oIUdwX7XSraaVV4gGMO46NdeQ==
X-Received: by 2002:a02:9003:: with SMTP id w3mr3072039jaf.31.1613246336315;
        Sat, 13 Feb 2021 11:58:56 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id j25sm6094323iog.27.2021.02.13.11.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 11:58:55 -0800 (PST)
Subject: Re: [PATCH net-next v2 0/7] mld: change context from atomic to
 sleepable
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210213175038.28171-1-ap420073@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3032e730-484f-d58d-8287-44e179c27ebb@gmail.com>
Date:   Sat, 13 Feb 2021 12:58:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213175038.28171-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

your patches still show up as 8 individual emails.

Did you use 'git send-email --thread --no-chain-reply-to' as Jakub
suggested? Please read the git-send-email man page for what the options do.
