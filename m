Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1425477D20
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbhLPUOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbhLPUOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:06 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6B0C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:05 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id a11so46333qkh.13
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgMGNu12b0u5EZLvIPKEEbjIjuc26Fwla3eujKVDpjc=;
        b=MucdEfH1+kiOhl6/C+MEzEzvLVjbm3NWNxuNT8tlHsvWCcjNE9MWwrFPHfegsJYu/T
         C89/hscz0sHJAyc85QKXuVEZz26p89EvhaS8oeWoHQnw29atrHgNre2vhOM8RBoeb4tm
         836sntqfuGmpt/vVB1tFATMb5Wtc87Pe0X4qpi3axScbHkN2krvun9kaZNE4I/LlBlC6
         PJs0tFYAl62XTwVxA424/OsTOXQqEJk0mP2Ki/2IvS6EbSmLg0bdbkS+j7CaquLBEhcA
         Dbo2kwgH8ndkCtor/ecydMEbUFAVPA7Ep9SttlfI6k3uqo37mp9fn34qlm0ufkq3nsWO
         Jo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgMGNu12b0u5EZLvIPKEEbjIjuc26Fwla3eujKVDpjc=;
        b=pgzNP6mpQnijk4Y5/BLk1BuQA+8yB3vcG/PF6vHY4RdygjlZ7xvCXCimC+Stq/uq3v
         lbv95TW2twkSTkLgbkhqTxMaaDrz4uakmA/0QF6RDXVamfR2gbPayRXAZESIokCnuP4z
         ZjWBFd0dXUUelhD5XhjBoCwONW2dUk8XGYLj5+owA/s9TmlA1UTTohZj3IQSMJcZgHnX
         EJbRPbd8KYUcBkjiFgg/ayFox/Wu1eiiW9zf3nh5+xHxT4GIgwnyX9foQWz4q6TW9dx2
         RcMulkQ1F1CKJMRpDceiiR4iic31mQyiG5UzO2PbZfSZnVfnsD+rQrY6Q4cLVBicdFdf
         UyIw==
X-Gm-Message-State: AOAM530amfYh3ezYX4IJkVPPJhIs/tLPyW++jcAttLl1N5siX5ITAxl9
        p8W+ifcNZ+8zylYqwp2upa0zvFdPRV3msQ==
X-Google-Smtp-Source: ABdhPJzos/uj8d9e4SCWDrDOScIeswx5r91Q0sfEJ2JwpJg941hJPVkaNiKX1akBZgUtHn8AhGhsqg==
X-Received: by 2002:a05:620a:1a92:: with SMTP id bl18mr13339381qkb.488.1639685644896;
        Thu, 16 Dec 2021 12:14:04 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:04 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: [PATCH net-next 00/13] net: dsa: realtek: MDIO interface and RTL8367S
Date:   Thu, 16 Dec 2021 17:13:29 -0300
Message-Id: <20211216201342.25587-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series refactors the current Realtek DSA driver to support MDIO
connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethernet
switch, with one of those 2 external ports supporting SGMII/High-SGMII. 

The old realtek-smi driver was linking subdrivers into a single
realtek-smi.ko After this series, each subdriver will be an independent
module required by either realtek-smi (platform driver) or the new
realtek-mdio (mdio driver). Both interface drivers (SMI or MDIO) are
independent, and they might even work side-by-side, although it will be
difficult to find such device. The subdriver can be individually
selected but only at buildtime, saving some storage space for custom
embedded systems. 

The subdriver rtl8365mb was renamed to rtl8367c. rtl8367c is not a real
model, but it is the name Realtek uses for their driver that supports
RTL8365MB-VC, RTL8367S and other siblings. The subdriver name was not
exposed to userland, but now it will be used as the module name. If
there is a better name, this is the last opportunity to rename it again
without affecting userland.

Existing realtek-smi devices continue to work untouched during the
tests. The realtek-smi was moved into a realtek subdirectory, but it
normally does not break things. 

I couldn't identify a fixed relation between port numbers (0..9) and
external interfaces (0..2), and I'm not sure if it is fixed for each
chip version or a device configuration. Until there is more info about
it, there is a new port property "realtek,ext-int" that can inform the
external interface. 

The rtl8367c still can only use those external interface ports as a
single CPU port. Eventually, a different device could use one of those
ports as a downlink to a second switch or as a second CPU port. RTL8367S
has an SGMII external interface, but my test device (TP-Link Archer
C5v4) uses only the second RGMII interface. We need a test device with
more external ports in use before implementing those features.

The rtl8366rb subdriver was not tested with this patch series, but it
was only slightly touched. It would be nice to test it, especially in an
MDIO-connected switch.

Best,

Luiz


