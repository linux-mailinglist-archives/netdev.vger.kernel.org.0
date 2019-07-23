Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DABA7229D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389660AbfGWWu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:50:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43936 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfGWWuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:50:55 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so14182393pld.10
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RSDqmg++SJExYXVKUJB9UF4Mabm3x3pMIMPWDPSldsE=;
        b=5Eqx+fbNrfkb69kc2CZjgrGGeux85H02afU2TmH5AnAxWb/GCxYd+TiRBYnjAP8xF8
         zAxbfpxK3oXttf4ybyfqihcNIfa7lcpdGCc8mEbuLJuHHj0G5BLR42O5qUVo8J5Vu5lD
         yrN6oD3JEXazugYbS1zHK+TstJVQhe/H4+aLxtpkxXL3q2zKXSA4YkX2cffJUvNTpCB8
         VlExhvt9IYtE6L7CRJNMAgNe0kPCixODn9PDcHfnwMfAb0+ZRiXBNifJCD1Uy11J5qDf
         zetDW030gfiETZtjQYESBg4otmVEm5ju/z7+fUW8DDFp3VRY5o0c6tKoP6s6j/uCaEvN
         NxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RSDqmg++SJExYXVKUJB9UF4Mabm3x3pMIMPWDPSldsE=;
        b=KyjwqabCbfLTO5WC8zJx6qL588nI0O/8rQWJ4NlcY27PM5r+/6IKIwKNfzWaEoz7mW
         NRdfc4yL77hj+9EOgWcOxN5liwyyxwCukSi4uszeFrsNLYS/gXhhSLBYIgCZhwnz4t5K
         bquXXVrXzDfklwj30ozP8xSt9wKHXmQarQWJ6xRSdrokc2oGxnIhusiYKElWdFzWGsYa
         nj49J4oV54GIHzD8rGtAaXikRGVNc1WF0KeM/NMvnJpambM4xO+M9GbANuP0RPK9zcOa
         +R5uPLhIBjnO47DoM9//DEymh0b69iOxbBA0cTipYITRsBWQYXuK1VResT/yEW0rwhY6
         z1dg==
X-Gm-Message-State: APjAAAWD2XH1JNZ9+cIZnZF/zSdnF0IPvKLtPPnLOHQAlZL8eBvGdlsl
        xiz/Nhp3QW/2jaFbC1y9BKfi+Fv/siSIKw==
X-Google-Smtp-Source: APXvYqyDruveYqXneL5mJVgs5Xx7cwh4Q2g/v9tvuQdENPpDW8JNNlBethc4kAkke+4x6hyPzNnVjw==
X-Received: by 2002:a17:902:9a04:: with SMTP id v4mr80308981plp.95.1563922254482;
        Tue, 23 Jul 2019 15:50:54 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j15sm49278638pfe.3.2019.07.23.15.50.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:50:53 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-14-snelson@pensando.io>
 <20190723.143507.1690183028498872104.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f2dad663-1ad4-f3b3-76b4-5842e51ec14c@pensando.io>
Date:   Tue, 23 Jul 2019 15:50:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.143507.1690183028498872104.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 2:35 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 22 Jul 2019 14:40:17 -0700
>
>> +static int ionic_get_link_ksettings(struct net_device *netdev,
>> +				    struct ethtool_link_ksettings *ks)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	int copper_seen = 0;
> Reverse christmas tree ordering here please.

Sure.  Most of these are because I wanted to do the one assignment 
first, from which the others are based.  I'll rework these to add the 
init lines after the declarations.  Same in the other files.

sln

>> +static int ionic_set_link_ksettings(struct net_device *netdev,
>> +				    const struct ethtool_link_ksettings *ks)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic *ionic = lif->ionic;
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	u8 fec_type = PORT_FEC_TYPE_NONE;
>> +	u32 req_rs, req_fc;
>> +	int err = 0;
> Likewise.
>> +static void ionic_get_pauseparam(struct net_device *netdev,
>> +				 struct ethtool_pauseparam *pause)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	uint8_t pause_type = idev->port_info->config.pause_type;
> Likewise.
>
>> +static int ionic_set_pauseparam(struct net_device *netdev,
>> +				struct ethtool_pauseparam *pause)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic *ionic = lif->ionic;
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	u32 requested_pause;
>> +	int err;
> Likewise.
>> +static int ionic_get_module_info(struct net_device *netdev,
>> +				 struct ethtool_modinfo *modinfo)
>> +
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	struct xcvr_status *xcvr;
> Likewise.
>
>> +static int ionic_get_module_eeprom(struct net_device *netdev,
>> +				   struct ethtool_eeprom *ee,
>> +				   u8 *data)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_dev *idev = &lif->ionic->idev;
>> +	struct xcvr_status *xcvr;
>> +	u32 len;
> Likewise.

