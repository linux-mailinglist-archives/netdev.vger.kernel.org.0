Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B3095916
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfHTIEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 04:04:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37313 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfHTIEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 04:04:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id y26so5029133qto.4
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 01:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=wajzv3AVu+DLNbi9/09U9wdk+g4fltInbvFXPto5n98=;
        b=t+ZzG5cShGxRyJ6pDwK3jStzn7IADwhlwiimqejNfE9n/CHH9KeE6OWgPghQDiy1PO
         bKq7F28Txwlt5EU30gd1S2WItWpwV6GVR8WNAuby6lZirKgtUT8DCzeb+Bil9Pvzd2E+
         IJUQTvOg+hc7DV4/yFeyPkmlrY4rE10q9eRC1WpXN7ElR3WVWDS0nHWVS3b0Men3qrAL
         573hfQjuN31nqya+UuXxDct+UVoZikwUcp6Sv/aUzf01nllvwxNJH+R4QPlzCi8l0Z9l
         QkwHPnUDWM6pgUrpatQNefX1xyx1avgjg0wGPscTh8/u9DJQ/crqZyOqju/BMxNaRbKn
         k/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=wajzv3AVu+DLNbi9/09U9wdk+g4fltInbvFXPto5n98=;
        b=aqLdmILuZegYHiggbo71c0+DbcDRgd6JflLGR1ndJ4M57r402YO1N27CyLGJV2UeQ7
         2e7+F/up425qsSFZMWU9NhUJuxniaMkW0MFBXD42g4qX6jspHY25oph/df3IWn3N8Xvk
         R/5AHYgoAgdA6iP+IF76IwyPsoGMtPItBgaHTbNDJysE5ml6u7ivd2E/zAosSyC44IvR
         HWII3IoNT6m5g4HBGpU8UguIl3KDPtBENZg1MlAOsAfz3RFEI6KUWWWDziOfdeEJ9N6i
         YXYfq9scZBbzgk0NrcY186AaVto98iMUREzgJ8oo96+BQ++ObhjyvUQ8UAN781JPPuyM
         CAHA==
X-Gm-Message-State: APjAAAUiLq77ysAhmqaxHg69Pc+LXO3UKjM51pwRIJ1ZS+6XGm4+Xo95
        aWlWQSellIV7mZ2I8wFJKDQ=
X-Google-Smtp-Source: APXvYqyTqLZKsyB1uf4WZrv8DScpJc88HpvFBgjWPm2cGi+RWmZIgduKh0yAYheYdhlIKqBBcha5tQ==
X-Received: by 2002:ac8:305b:: with SMTP id g27mr25789560qte.127.1566288285045;
        Tue, 20 Aug 2019 01:04:45 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j18sm7817579qth.24.2019.08.20.01.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 01:04:44 -0700 (PDT)
Date:   Tue, 20 Aug 2019 04:04:43 -0400
Message-ID: <20190820040443.GB4919@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 0/6] Dynamic toggling of vlan_filtering for
 SJA1105 DSA
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 02:59:56 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> This patchset addresses a few limitations in DSA and the bridge core
> that made it impossible for this sequence of commands to work:
> 
>   ip link add name br0 type bridge
>   ip link set dev swp2 master br0
>   echo 1 > /sys/class/net/br0/bridge/vlan_filtering
> 
> Only this sequence was previously working:
> 
>   ip link add name br0 type bridge vlan_filtering 1
>   ip link set dev swp2 master br0

This is not quite true, these sequences of commands do "work". What I see
though is that with the first sequence, the PVID 1 won't be programmed in
the hardware. But the second sequence does program the hardware.

But following bridge members will be correctly programmed with the VLAN
though. The sequence below programs the hardware with VLAN 1 for swp3 as
well as CPU and DSA ports, but not for swp2:

    ip link add name br0 type bridge
    ip link set dev swp2 master br0
    echo 1 > /sys/class/net/br0/bridge/vlan_filtering
    ip link set dev swp3 master br0

This is unfortunately also true for any 802.1Q VLANs. For example, only VID
43 is programmed with the following sequence, but not VID 1 and VID 42:

    ip link add name br0 type bridge
    ip link set dev swp2 master br0
    bridge vlan add dev swp2 vid 42
    echo 1 > /sys/class/net/br0/bridge/vlan_filtering
    bridge vlan add dev swp2 vid 43

So I understand that because VLANs are not propagated by DSA to the hardware
when VLAN filtering is disabled, a port may not be programmed with its
bridge's default PVID, and this is causing a problem for tag_8021q.

Please reword so that we understand better what is the issue being fixed here.

> 
> On SJA1105, the situation is further complicated by the fact that
> toggling vlan_filtering is causing a switch reset. However, the hardware
> state restoration logic is already there in the driver. It is a matter
> of the layers above which need a few fixups.
> 
> Also see this discussion thread:
> https://www.spinics.net/lists/netdev/msg581042.html
> 
> Patch 1/6 is not functionally related but also related to dsa_8021q
> handling of VLANs and this is a good opportunity to bring up the subject
> for discussion.

So please send 1/6 as a separate patch and bring up the discussion there.


Thanks,

	Vivien
