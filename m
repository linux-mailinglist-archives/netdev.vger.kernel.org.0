Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06DD4CB47C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiCCBxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiCCBxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:53:36 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B192232EC2
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 17:52:51 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id j24so3480544oii.11
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 17:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJq/3cG0hVwKXZA60SUN+lPgJHx9II62bg9E+fAgP60=;
        b=qR+VORl1dwD+fSD17/D1mC/ZGmILuk2yB8ykX+0jfGppNesa0F62yw+pgp+pQIyMY7
         oElvDBOmMFwyP3Wf3LG3ssR3/q1HXcD4zk5+Q/Vsd63CkI+Ps3uBUG/1V6fB+40MHyGp
         anrJnrwtqfs5GWPJyar88iA3w0gBz/7bJfUjnOphHf3g+EhmUc6nWWxVcDCDr5HEPNzR
         a0UMmLKVlSs5Xf7V8u/wNDeXzzBPRsR7flcA+uKP78TaiGFtUDf5FgtBl0gR+vSeENGl
         0BVnSA9r5qWXJdldyJa3c0SlDxelxdnkdnB82xwyIlGZ6I9xlCyO9OFkxrAYVCmlQC2x
         jHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJq/3cG0hVwKXZA60SUN+lPgJHx9II62bg9E+fAgP60=;
        b=1DiSB5vjH2cly1WU4x3p/RLtZXFWIkOIvhis+rNwQ/Z7Gzh1i4Ub11/YPiQ2TeIFqC
         PyLhJgonTazurX41WAsdMJ/hpfvF2r0OIQ+mwgK+Tv7xVKp247mK31O88fQ1b4dwPoCz
         6NvZyEMu29nBP9afI5ew6euZ1XfdDJMmBaKu5sNdLm7633EQAMgb+mEMahccE96h1vXf
         BVwzh3d2wp/h9IQIuYdKY6Ufe4JNwR8oHlmYqwppV7NFkyc0tZx6DlgcKJHMq3N9NLq3
         Hgtv4Z7C3L/fvlWHGu/J1zJdfnPSp8fmTeEA6trCPqp+3TYE1fkoWA2zvMRmafLN50yh
         cshg==
X-Gm-Message-State: AOAM533RHj5dNoXWHdff9MOap/0Gz1Jj+7aOe1LC+R2uNnHaACSuArTt
        MFJwuQEIfEkEi5xu5FDN/OOgVxKwJ0Y=
X-Google-Smtp-Source: ABdhPJxfiCxm88JSg52+8JA+JvDsTzc05fXpA5OZH4PiTAa/+TjnDodatF9auofS5pZs8SHKuY0tiQ==
X-Received: by 2002:a05:6808:f8f:b0:2d7:a316:490 with SMTP id o15-20020a0568080f8f00b002d7a3160490mr2589681oiw.56.1646272370541;
        Wed, 02 Mar 2022 17:52:50 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a10-20020a05687073ca00b000d128dfeebfsm446310oan.2.2022.03.02.17.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:52:49 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: [PATCH net-next v5 0/3] net: dsa: realtek: add rtl8_4t tag
Date:   Wed,  2 Mar 2022 22:52:32 -0300
Message-Id: <20220303015235.18907-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for rtl8_4t tag. It is a variant of
rtl8_4 tag, with identical values but placed at the end of the packet
(before CRC).

It forces checksum in software before adding the tag as those extra
bytes at the end of the packet would be summed together with the rest of
the payload. When the switch removes the tag before sending the packet
to the network, that checksum will not match.

It might be useful to diagnose or avoid checksum offload issues. With an
ethertype tag like rtl8_4, the cpu port ethernet driver must work with
cksum_start and chksum_offset to correctly calculate checksums. If not,
the checksum field will be broken (it will contain the fake ip header
sum).  In those cases, using 'rtl8_4t' might be an alternative way to
avoid checksum offload, either using runtime or device-tree property.

Regards,

Luiz

v4-v5)
- tags in alphabetical order in dsa_port.yaml
- remove ret var from rtl8365mb_change_tag_protocol
- Comment typos fixes

v3-v4)
- added rtl8_4 and rtl8_4t to dsa_port.yaml
- removed generic considerations about checksum problems with DSA tags.
  They belong to Documentation/networking/dsa/dsa.rst

v2-v3)
- updated tag documentation (file header)
- do not remove position and format from rtl8365mb_cpu
- reinstate cpu to rtl8365mb
- moved rtl8365mb_change_tag_protocol after rtl8365mb_cpu_config
- do not modify rtl8365mb_cpu_config() logic
- remove cpu arg from rtl8365mb_cpu_config(); get it from priv
- dropped tag_protocol from rtl8365mb. It is now derived from
  cpu->position.
- init cpu struct before dsa_register as default tag must be already
  defined before dsa_register()
- fix formatting issues

v1-v2)
- remove mention to tail tagger, use trailing tagger.
- use void* instead of char* for pointing to tag beginning
- use memcpy to avoid problems with unaligned tags
- calculate checksum if it still pending
- keep in-use tag protocol in memory instead of reading from switch
  register


