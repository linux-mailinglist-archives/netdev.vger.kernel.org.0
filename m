Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE17E2B8187
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgKRQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKRQL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:11:29 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E8FC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:11:29 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id r7so2299972qkf.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7xkhBcTNdzLp076bmw5BAZb3jZJ2l6hd1vafKSqS9I4=;
        b=TI6EzIRCxsiT5KIsrAve5YepOQKHEylUVEsvjvUbdPc1ipn4pG8hAE7F0dOk8Y3zVi
         mxWj3AmJ1TR8p4Ouaq6NYspeAxrtWSIulM/jdu3khxhgDLMH/6TaqldFJI1hnvr3yT+x
         SOHcugULm+kU1rlQgfybak5phaju9ivKVy5mwQ+f7xFC8qYgZ/EjKZUzOAqzsXoh/vE5
         wlp2qe2vOVBQ2Fr1OnObwbiLN4Z/NDjdrKEAbVvVzEXRT1MLYeF8IsEd/ruhoxpdDsFz
         eb4HlmoO0NRUTihQPjz/DR7HOpwG3HvsuEToc7A23DrXlSQVe7Nct9MhkynjvCdFikx+
         Exvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7xkhBcTNdzLp076bmw5BAZb3jZJ2l6hd1vafKSqS9I4=;
        b=l+hDSGN1C76Jyf0kx8GR6aQhrnVxz9+jo0PI4fOiQdj37BHsT51KoLtc1J2qvs5o2O
         E/ZvBQ8MVCxzbybrsiScps+UJGbWFLXMYuKbku9OzIC9Pn+hl1lXd5VMEmXEboBR9fVN
         W1voTXYUiUxbOBgjDg9XqwVSJbd/nA4rdjBxOCXN9WKygFlXYQG7IbIcTaS02e97R8Rd
         BMoUQAcMx96QWrWLZyIlBvnBhNVFG7ORfMKanM5B6xisux+ihlrrJokHJGQce3IAaMtK
         52V2c6Vury6387NCgNnraYhYQeQ8rAyt/8K4xRxTEagpnF7DA44Ep5dl9Iq5jgGVjKB3
         pmaQ==
X-Gm-Message-State: AOAM531QEQSfKxgpX4vbHyKtEjui4UqH++PaPpemA3eg0ut7+EPOtODc
        w7Lb7jkVfj9QMXsBuIteoHWLgg==
X-Google-Smtp-Source: ABdhPJz7SeUJCqjikWbLc8FsaxZtUMJf5TsrYviswMlWqgFdT+WInuD2ixb52cF+NXq7tA0dGZJIWg==
X-Received: by 2002:a37:a783:: with SMTP id q125mr5532598qke.10.1605715888700;
        Wed, 18 Nov 2020 08:11:28 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id p73sm16991333qka.79.2020.11.18.08.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 08:11:27 -0800 (PST)
Subject: Re: [RFC, net-next] net: qos: introduce a redundancy flow action
To:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, Arvid.Brodin@xdin.com,
        m-karicheri2@ti.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivan.khoronzhuk@linaro.org, andre.guedes@linux.intel.com,
        allan.nielsen@microchip.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, Cong Wang <xiyou.wangcong@gmail.com>
References: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
 <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <fc5d88d6-ca5e-59f5-cf3d-edfecce46dd4@mojatatu.com>
Date:   Wed, 18 Nov 2020 11:11:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-17 2:00 p.m., Joergen Andreasen wrote:
> The 11/17/2020 14:30, Xiaoliang Yang wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> This patch introduce a redundancy flow action to implement frame
>> replication and elimination for reliability, which is defined in
>> IEEE P802.1CB.
>>
>> There are two modes for redundancy action: generator and recover mode.
>> Generator mode add redundancy tag and replicate the frame to different
>> egress ports. Recover mode drop the repeat frames and remove redundancy
>> tag from the frame.
>>
>> Below is the setting example in user space:
>>          > tc qdisc add dev swp0 clsact
>>          > tc filter add dev swp0 ingress protocol 802.1Q flower \
>>                  skip_hw dst_mac 00:01:02:03:04:05 vlan_id 1 \
>>                  action redundancy generator split dev swp1 dev swp2
>>
>>          > tc filter add dev swp0 ingress protocol 802.1Q flower
>>                  skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \
>>                  action redundancy recover
>>

Please CC _all_ maintainers for best feedback (+Cc Cong)
and it is unnecessary to cc lists like linux-kernel (removed).

We already have mirroring + ability to add/pop tags.
Would the following not work?

Example, generator mode:
tc filter add dev swp0 ingress protocol 802.1Q flower \
action vlan push id 789 protocol 802.1q \
action mirred egress mirror dev swp1 \
action mirred egress mirror dev swp2

recovery mode:
tc filter add dev swp0 ingress protocol 802.1Q flower \
skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \
actopm vlan pop


cheers,
jamal
