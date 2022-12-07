Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41746457F8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLGKgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLGKgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:36:00 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646832D741
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:35:56 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221207103553epoutp03446a062a6923d6da53ec8d16ac1b0e3a~ufHT20V0B2944429444epoutp03I
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:35:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221207103553epoutp03446a062a6923d6da53ec8d16ac1b0e3a~ufHT20V0B2944429444epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670409353;
        bh=NbFszwCbINq2fEc/CQPJNHwq3gmonJ9EbdaIqFoiV7w=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qeKPEmnNB2tx7nswYC3gfV1Z4BTbtw3na/X7aJJ2dXGaA6vI6aMSqQpmadihOY2BS
         HNkgrOJehQBb8yQ6N6qJW9PEaigeFHY1k0rNaFdz0rc0XYRxBmu4bDVCbKBhwj74Q+
         r40cN3PoocGYiITyqOX74HLY68hqmXhqpiESggus=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221207103552epcas5p300a09b4a6e5f12d0fe11d903fccd0fbc~ufHTHm2ym2665726657epcas5p3Z;
        Wed,  7 Dec 2022 10:35:52 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4NRtwl11mrz4x9Pt; Wed,  7 Dec
        2022 10:35:51 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.57.56352.68C60936; Wed,  7 Dec 2022 19:35:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221207100642epcas5p26c8f3f898ad8ac434092c702a788c0ff~uet1JZX5b2930429304epcas5p2w;
        Wed,  7 Dec 2022 10:06:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221207100642epsmtrp1ea378f600dac970c84e46b6f0cebe582~uet1IYEfi0203002030epsmtrp1b;
        Wed,  7 Dec 2022 10:06:42 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-da-63906c86c9ce
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0B.89.18644.2B560936; Wed,  7 Dec 2022 19:06:42 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221207100639epsmtip219a657681b855ae3b63485630ef5db2d~uetyQ-7dy0620706207epsmtip24;
        Wed,  7 Dec 2022 10:06:39 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        Vivek Yadav <vivek.2311@samsung.com>
Subject: [Patch v4 0/2] can: mcan: Add MCAN support for FSD SoC
Date:   Wed,  7 Dec 2022 15:36:30 +0530
Message-Id: <20221207100632.96200-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmlm57zoRkg9YbTBYP5m1jszi0eSu7
        xZzzLSwW84+cY7V4euwRu0Xfi4fMFhe29bFabHp8jdVi1fepzBYPX4VbXN41h81ixvl9TBbr
        F01hsTi2QMzi2+k3jBaLtn5ht3j4YQ+7xawLO1gtWvceYbe4/WYdq8WvhYdZLJbe28nqIOax
        ZeVNJo8Fm0o9Pl66zeixaVUnm8eda3vYPDYvqffo/2vg8X7fVTaPvi2rGD3+Nc1l9/i8SS6A
        OyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoVSWF
        ssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFC
        dsbjb6dYCk5qVjz9c5ulgXG1YhcjJ4eEgInE0s4NLF2MXBxCArsZJS6uPMMKkhAS+MQoMe+B
        AETiM6PExBW7mWA6ls1azAyR2MUo0bmiiw3CaWWSWHlqBlg7m4CWxOPOBWBzRQRWM0ls+fyQ
        EcRhFpjFJLGk+RYLSJWwgL3E1sZ9QAkODhYBVYktC/lBwrwC1hLPV55hgVgnL7F6wwGwdRIC
        Jzgkzry/AZVwkbh8aTYbhC0s8er4FnYIW0riZX8blJ0sseNfJyuEnSGxYOIeRgjbXuLAlTks
        IHuZBTQl1u/ShwjLSkw9tQ7sTWYBPone30+gXuaV2DEPxlaRePF5AitIK8iq3nPCEKaHROsM
        fxBTSCBWYuJ02QmMsrMQxi9gZFzFKJlaUJybnlpsWmCcl1oOj6bk/NxNjOD0q+W9g/HRgw96
        hxiZOBgPMUpwMCuJ8L7Y2JssxJuSWFmVWpQfX1Sak1p8iNEUGF4TmaVEk/OBGSCvJN7QxNLA
        xMzMzMTS2MxQSZx36ZSOZCGB9MSS1OzU1ILUIpg+Jg5OqQamwvdymvXfW9//jzNoSFvddsWv
        zJ+PW6dGfHvukimdYR6c4nMa59teVTD45LRDqK+P/86m3niVI1wbLfi+SKSaWW8s5TV+Xs4j
        0+nAl/PyV5jqPLvTFzbxPE7VFvmRdCfpouZ9q22X4y6fs1D81HGDT4vByyL8y+ZliYwpn6pu
        bi/pPTSnO/llvOWlyDNcZccyzG8vUM87zrbBzvnhsYcuf3IuSzabnRWUsdkxI/Uc52ZTB7Ov
        82/Gn/2kusbYI3jdvzVy/dsWrTD/e7fj6Au5hLfxHaxxvkrMjycAM8mPMgs3FruzaTPuf/kR
        ma2gHGE7L0VAcfnSNdaH3xbMrxWZsWzr6rA7zsLWrb48r5VYijMSDbWYi4oTAfG71EpIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzVRfSyUcQD2u/czuXk70Zs+rLPEraSifpXI1uptK0mRPta56e36cB+7N3Vp
        07nSRoXVtZkQwrg2p8MlceWyiyhWhxq1OJeY5hrTx8raUf89n3v+eEhEYEd8ydPyc6xKLkkW
        4u6o6bnQb42RzU0Kya5cBj8VmXBoqa0nYEHXVRTea32NQYd1iIDZXwYR2G3KxqDR3otB/fc7
        CBwcOwTfNhbgMK/LzIOGUh0KrcU+cLpjHMDS+ikCDjqbCJjf3YDBjOZWAvaPV2PwV8lzFJZ/
        fIxt92Hqqt7zmGJjCvPtTT9gjPpMnBnobcKZ2rLLTM6fEGbC3IMz2XV6wMxoCwlm0rg8Zv4R
        9/ATbPLp86xqbUSi+yn79EtU2R6kdvzuRzXgwYosMI+kqVC6Iv8+kgXcSQHVAOjmWy3EnOFL
        6zpH0TnsRVfNjMzqAuoKj04fi3NhnBLR9sxi1FVeSD3h0V+vFxIuglClPHrUdhNxpbyoSLo+
        3QyyAEmi1Eq6rsTTJfOprfRIVee/AT/6Qc0zJBd4FAM3PVjMKjmZVMatU66XsxeCOYmMS5FL
        g5MUMiOY/UEkagBNemewBfBIYAE0iQgX8r88vJkk4J+QXExlVQqxKiWZ5SxgCYkKF/G7s9rF
        AkoqOceeZVklq/rv8sh5vhpe5ufAIr+WtD92/sevIErs3RsaXdnWvrGeUR0c19HilE3byjq0
        fcwW/4CJYYNzZ6DaAeJYscFytH0gUr9gMqCc7PM03o55GtOLGMyjXgp7OGfbnBpujSJ3KU37
        ErbatIqR3Hgmwz+qdRV3ScosWYRVqzYbHulv9ITlXTSXB3Xgox9s0cciBtQO7+Guw0feFUyv
        rjmg9bil2Gt69d1L43/SWY2HtgFIOq/9kEWGvZFtEDfXrAIaPGJo2YszTXcfxXck7OhTB8T2
        x8VW+DSuSMwIljbukb2PbMj55gxPG/7p5lj66yoWQu7vOTOVtzsdKzx+0nN6xlmY2K1LsApR
        7pRknQhRcZK/sIz5XvYCAAA=
X-CMS-MailID: 20221207100642epcas5p26c8f3f898ad8ac434092c702a788c0ff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221207100642epcas5p26c8f3f898ad8ac434092c702a788c0ff
References: <CGME20221207100642epcas5p26c8f3f898ad8ac434092c702a788c0ff@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MCAN instances present on the FSD platform.

Vivek Yadav (2):
  can: m_can: Call the RAM init directly from m_can_chip_config
  arm64: dts: fsd: Add MCAN device node

changes since v3:

[PATCH v3 1/2] can: m_can: Move mram init to mcan device setup
https://lore.kernel.org/lkml/20221122105455.39294-2-vivek.2311@samsung.com/
	1: Addressed review comment given by Marc Kleine-Budde   
	   a) Call the RAM init directly from m_can_chip_config.
	   b) If we call m_can_init_ram() from m_can_chip_config(),
	      then remove it from the tcan's tcan4x5x_init() functions,
	      and from m_can_class_resume(). It should only be called
	      once for open and once for resume.

changes since v2:

[PATCH v2 1/6] dt-bindings: Document the SYSREG specific compatibles found
on FSD SoC
link:
https://lore.kernel.org/lkml/20221109100928.109478-2-vivek.2311@samsung.com/
	1: Addressed review comment given by Krzysztof Kozlowski
	   a) As per suggestion separated this patch and posted separately.
	      ref: https://www.spinics.net/lists/kernel/msg4597970.html 

[PATCH v2 2/6] dt-bindings: can: mcan: Add ECC functionality to message ram
link: 
https://lore.kernel.org/lkml/20221109100928.109478-3-vivek.2311@samsung.com/
	1: Addressed review comment given by Krzysztof Kozlowski
	   a) For now I am dropping this. I will reconsider the implementation
	      and will resend as separate patch.

[PATCH v2 3/6] arm64: dts: fsd: add sysreg device node
link:
https://lore.kernel.org/lkml/20221109100928.109478-4-vivek.2311@samsung.com/
	1: Addressed review comment given by Krzysztof Kozlowski
	   a) Dropped Cc from commit message.
	   b) As per suggestion separated this and corresponding DT-bindin
	      patch and posted separately.
	      ref: https://www.spinics.net/lists/kernel/msg4597921.html

[PATCH v2 4/6] arm64: dts: fsd: Add MCAN device node
link: 
https://lore.kernel.org/lkml/20221109100928.109478-5-vivek.2311@samsung.com/
	1: Addressed review comment given by Krzysztof Kozlowski
	   a) Aligned the lines.

[PATCH v2 5/6] can: m_can: Add ECC functionality for message RAM
link: 
https://lore.kernel.org/lkml/20221109100928.109478-6-vivek.2311@samsung.com/
	1: Addressed review comment given by Krzysztof Kozlowski
	   a) We are dropping this for now and will reconsider it's
	      implementation and resend as separate patch.

[PATCH v2 6/6] arm64: dts: fsd: Add support for error correction code for
message RAM
link: 
https://lore.kernel.org/lkml/20221109100928.109478-7-vivek.2311@samsung.com/
	1: Addressed review comment given by Krzysztof Kozlowski
	   a) Subject is updated and patch go via ARM SOC tree, we will
	      resend this as separate patch along with ECC patch.

changes since v1:

[PATCH 0/7] can: mcan: Add MCAN support for FSD SoC 
	1: Addressed review comment given by  Marc Kleine-Budde
	   a) Added my signed off.

[PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to message ram
link: 
https://lore.kernel.org/netdev/87k04oxsvb.fsf@hardanger.blackshift.org/ 
	1: Addressed review comment given by  Marc Kleine-Budde
	   a) Added an example to the yaml that makes use of the 
	      mram-ecc-cfg property.
	   b) Added prefix to "mram-ecc-cfg" property and
	      "$ref: /schemas/types.yaml#/definitions/phandle".

[PATCH 4/7] can: mcan: enable peripheral clk to access mram
link:
https://lore.kernel.org/netdev/20221021095833.62406-5-vivek.2311@samsung.com/
	1: Addressed review comment given by  Marc Kleine-Budde
	   a) Moved mram init into m_can_dev_setup function by then
	      clocks are enabled and prevent probe failure.
	   b) Added the platform init ops in m_can_plat_ops and
	      moved mram init into it.

[PATCH 5/7] arm64: dts: fsd: Add MCAN device node
link:
https://lore.kernel.org/netdev/20221021095833.62406-6-vivek.2311@samsung.com/
	1: Addressed review comment given by  Marc Kleine-Budde
           a) Added the DT people on Cc.

[PATCH 6/7] can: m_can: Add ECC functionality for message RAM
link:
https://lore.kernel.org/netdev/20221021095833.62406-7-vivek.2311@samsung.com/
	1: Addressed review comment given by kernel test robot.
	   a) Addressed missing prototypes warnings.
	2: Addressed review comment given by  Marc Kleine-Budde
	   a) Sorted the declaration of local variable by reverse Christmas 
	      tree.
	   b) Used syscon_regmap_lookup_by_phandle_args to get the syscon
	      Base Address and offset.
	   c) Used FIELD_PREP instead of logical operation.
	   d) Used regmap_read_poll_timeout API to give timeout condition
	      for ECC cfg done status instead of using while loop counter.
	   e) Moved all the ECC mcaros in m_can.c file and changed the name
	      with a common prefix M_CAN.
	   f) Moved ECC init into platform init function called during m_can
	      device setup.

 arch/arm64/boot/dts/tesla/fsd-evb.dts      | 16 +++++
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 28 +++++++++
 arch/arm64/boot/dts/tesla/fsd.dtsi         | 68 ++++++++++++++++++++++
 drivers/net/can/m_can/m_can.c              | 32 ++++++++--
 drivers/net/can/m_can/m_can_platform.c     |  4 --
 drivers/net/can/m_can/tcan4x5x-core.c      |  5 --
 6 files changed, 138 insertions(+), 15 deletions(-)

-- 
2.17.1

