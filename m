Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E46C39CB7B
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 00:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhFEWmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 18:42:32 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:35741 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFEWmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 18:42:32 -0400
Received: by mail-wr1-f42.google.com with SMTP id m18so13019698wrv.2;
        Sat, 05 Jun 2021 15:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=UufnybqE4cq7DxGgeJzoFiDmrclus4J9QFmlfRc8QqM=;
        b=RaDXfEyBM/gucUBsbztTUDNxjPkWGImwVNv5AkWYOmM44MIoM2KgZAK67y9KPsSnQX
         vxHYXK6x1QpGZxpzGWEJ0luhOZRALSj7YZsV3YCLCHufWdBTsIHI+0M5XNCQL0zXM2e8
         /l14ImEp9vt26siLgRsxTHlOvXBFff56PixU1tj/EJYlJuU+J4N8SgY4nGLrxbplFo63
         ViEHZpaKlwW3hraeDwxlnQxr8gG+2hHfo9Tn/XI2QqqkVBQBJ5ekEqMbjgFPiwOS3cZV
         eHjSbNd7zTvbWEl5Rhsgn0z+sO2Iw+odTEMKQlGsKnggNyLEe0OINV1zZvVq9jJ8QEWD
         qUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UufnybqE4cq7DxGgeJzoFiDmrclus4J9QFmlfRc8QqM=;
        b=Y/uF69tbTif66hoJuFGEmJcNqu1ZKwtJtPFkeC68D8AyAeQT0JvXNjS+LR88Ntgkcp
         hIm9fWjSMKDpmYxY59PSFl5DenptewGKbrauM60QtydgljqWOPubB3fvUW2Wfb3NjHvo
         OQoETXbpo4X2or0gPgoyizlyoAc5tJJw4Pgd94sfOFq3ThEEeW+BMOe0zhMKN8Phh5cF
         Zr7GTB10/CYrrceJg+oU3AcGv0nYZcgsE6ZXsPoHag7TR0Z5vgr6knFXYIdP3/kMRSo4
         7N3PYJrHKTWwIXhxnWTBgFlllST5PFRb3S8W6cfNQurZKD7XD68X2hQkxwb/GCno/vRW
         KQ5A==
X-Gm-Message-State: AOAM5305+A8qvAKwUAqbzSJVtmn6SN9F7T0cBBXZCUHlnNIJKvmeWYEA
        sCPsv8gipy6HJVf+mghKzuJIy3lbR0nh4w==
X-Google-Smtp-Source: ABdhPJxKGjnGjVVU0y+lofqaeIqota/iY14qwfGcuDzurQW8lsMDv9PLH3lR0ok8b0tozlzW+b3pLQ==
X-Received: by 2002:adf:ea4c:: with SMTP id j12mr9940614wrn.64.1622932766250;
        Sat, 05 Jun 2021 15:39:26 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id l16sm12818672wmj.47.2021.06.05.15.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 15:39:25 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
Date:   Sat, 5 Jun 2021 23:39:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YLvgI1e3tdb+9SQC@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06/2021 21:35, Andrew Lunn wrote:

>> The tested case is a Meraki MX65 which features two QCA8337 switches with
>> their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.
> Hi Matthew
>
> The BCM58625 switch is also running DSA? What does you device tree
> look like? I know Florian has used two broadcom switches in cascade
> and did not have problems.
>
>     Andrew

Hi Andrew

I did discuss this with Florian, who recommended I submit the changes. Can
confirm the b53 DSA driver is being used. The issue here is that tagging
must occur on all ports. We can't selectively disable for ports 4 and 5
where the QCA switches are attached, thus this patch is required to get
things working.

Setup is like this:
                       sw0p2     sw0p4            sw1p2     sw1p4 
    wan1    wan2  sw0p1  +  sw0p3  +  sw0p5  sw1p1  +  sw1p3  +  sw1p5
     +       +      +    |    +    |    +      +    |    +    |    +
     |       |      |    |    |    |    |      |    |    |    |    |
     |       |    +--+----+----+----+----+-+ +--+----+----+----+----+-+
     |       |    |         QCA8337        | |        QCA8337         |
     |       |    +------------+-----------+ +-----------+------------+
     |       |             sw0 |                     sw1 |
+----+-------+-----------------+-------------------------+------------+
|    0       1    BCM58625     4                         5            |
+----+-------+-----------------+-------------------------+------------+

Relevant sections of the device tree are as follows:

mdio@0 {
    reg = <0x0>;
    #address-cells = <1>;
    #size-cells = <0>;

    phy_port6: phy@0 {
        reg = <0>;
    };

    phy_port7: phy@1 {
        reg = <1>;
    };

    phy_port8: phy@2 {
        reg = <2>;
    };

    phy_port9: phy@3 {
        reg = <3>;
    };

    phy_port10: phy@4 {
        reg = <4>;
    };

    switch@10 {
        compatible = "qca,qca8337";
        #address-cells = <1>;
        #size-cells = <0>;
        reg = <0x10>;
        dsa,member = <1 0>;

        ports {
            #address-cells = <1>;
            #size-cells = <0>;
            port@0 {
                reg = <0>;
                label = "cpu";
                ethernet = <&sgmii1>;
                phy-mode = "sgmii";
                fixed-link {
                    speed = <1000>;
                    full-duplex;
                };
            };

            port@1 {
                reg = <1>;
                label = "sw1p1";
                phy-handle = <&phy_port6>;
            };

            port@2 {
                reg = <2>;
                label = "sw1p2";
                phy-handle = <&phy_port7>;
            };

            port@3 {
                reg = <3>;
                label = "sw1p3";
                phy-handle = <&phy_port8>;
            };

            port@4 {
                reg = <4>;
                label = "sw1p4";
                phy-handle = <&phy_port9>;
            };

            port@5 {
                reg = <5>;
                label = "sw1p5";
                phy-handle = <&phy_port10>;
            };
        };
    };
};

mdio-mii@2000 {
    reg = <0x2000>;
    #address-cells = <1>;
    #size-cells = <0>;

    phy_port1: phy@0 {
        reg = <0>;
    };

    phy_port2: phy@1 {
        reg = <1>;
    };

    phy_port3: phy@2 {
        reg = <2>;
    };

    phy_port4: phy@3 {
        reg = <3>;
    };

    phy_port5: phy@4 {
        reg = <4>;
    };

    switch@10 {
        compatible = "qca,qca8337";
        #address-cells = <1>;
        #size-cells = <0>;
        reg = <0x10>;
        dsa,member = <2 0>;

        ports {
            #address-cells = <1>;
            #size-cells = <0>;
            port@0 {
                reg = <0>;
                label = "cpu";
                ethernet = <&sgmii0>;
                phy-mode = "sgmii";
                fixed-link {
                    speed = <1000>;
                    full-duplex;
                };
            };

            port@1 {
                reg = <1>;
                label = "sw0p1";
                phy-handle = <&phy_port1>;
            };

            port@2 {
                reg = <2>;
                label = "sw0p2";
                phy-handle = <&phy_port2>;
            };

            port@3 {
                reg = <3>;
                label = "sw0p3";
                phy-handle = <&phy_port3>;
            };

            port@4 {
                reg = <4>;
                label = "sw0p4";
                phy-handle = <&phy_port4>;
            };

            port@5 {
                reg = <5>;
                label = "sw0p5";
                phy-handle = <&phy_port5>;
            };
        };
    };
};


&srab {
    compatible = "brcm,bcm58625-srab", "brcm,nsp-srab";
    status = "okay";
    dsa,member = <0 0>;

    ports {
        #address-cells = <1>;
        #size-cells = <0>;

        port@0 {
            label = "wan1";
            reg = <0>;
        };

        port@1 {
            label = "wan2";
            reg = <1>;
        };

        sgmii0: port@4 {
            label = "sw0";
            reg = <4>;
            fixed-link {
                speed = <1000>;
                full-duplex;
            };
        };

        sgmii1: port@5 {
            label = "sw1";
            reg = <5>;
            fixed-link {
                speed = <1000>;
                full-duplex;
            };
        };

        port@8 {
            ethernet = <&amac2>;
            label = "cpu";
            reg = <8>;
            fixed-link {
                speed = <1000>;
                full-duplex;
            };
        };
    };
};

Matthew

