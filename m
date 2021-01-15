Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18CC2F719B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733031AbhAOEar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:30:47 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:58830 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbhAOEar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:30:47 -0500
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2021 23:30:46 EST
Received: from [192.168.188.110] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id BD5C15C1DD3;
        Fri, 15 Jan 2021 11:53:49 +0800 (CST)
Subject:  Ktls RX offload in CX6 of mellanox
To:     tariqt@nvidia.com, borisp@nvidia.com
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <616cd09a-c0ba-68e1-5d72-96b0f9abd2e4@ucloud.cn>
 <AM7PR05MB7092681958225E065CAD9174B0480@AM7PR05MB7092.eurprd05.prod.outlook.com>
 <HE1PR05MB473281BEC529F6705646885DB4480@HE1PR05MB4732.eurprd05.prod.outlook.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b0053adc-760e-d3ae-5a88-34bea387aedb@ucloud.cn>
Date:   Fri, 15 Jan 2021 11:53:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <HE1PR05MB473281BEC529F6705646885DB4480@HE1PR05MB4732.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSh5KQ0hIS0hJHk5CVkpNSktNQ0lDSEtLTktVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0NJQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OTY6PQw*ET0xCBYtIikJChFI
        OU0wFCNVSlVKTUpLTUNJQ0hLSkJLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJTUxKNwY+
X-HM-Tid: 0a77042d8cbe2087kuqybd5c15c1dd3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mellanox team.

I test the ktls offload feature with CX6 dx with net-next tree.

I found the driver already support the KTLS rx offload function

My firmware version is the latest one 22.29.1016
 
According to the document:
https://docs.mellanox.com/display/OFEDv521040/Kernel+Transport+Layer+Security+%28kTLS%29+Offloads

With the 22.29.1016 FW, The RX offload is supported now.


# lspci | grep Ether
b3:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
b3:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [ConnectX-6 Dx]

# ethtool -i net2
driver: mlx5_core
version: 5.0-0
firmware-version: 22.29.1016 (MT_0000000430)
expansion-rom-version: 
bus-info: 0000:b3:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes



# ethtool -K net2 |  grep tls-hw

tls-hw-tx-offload: on
tls-hw-rx-offload: off [fixed]


But I found the RX offload is not supported currently?


I found the mlx5_accel_is_ktls_rx(mdev) will return false and it leads this feature
not supported. So it means the current FW also does not support RX offload?


BR

wenxu

