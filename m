Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178946195D9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKDMIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiKDMIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:08:30 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FAC2CE3F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:08:25 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221104120824epoutp0400e147b0bfdaf57eae9ef01699e18c0b~kYFqPXTK90732607326epoutp04b
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:08:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221104120824epoutp0400e147b0bfdaf57eae9ef01699e18c0b~kYFqPXTK90732607326epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667563704;
        bh=JWP5+qRGhNLygy6I/Jxmbk0KPHj1dCzTUNcLElYci/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBwF7qpgUXwJH+lSSHAfPMKRUioxTVXc1v+zrKI6EHboG2WXXq48hRFcsAF4E0B3H
         e/uEarMVdl6hdBslIDzh4b2NEB6Ozn/obA30CfsdG0ULgp8r60onb7J9eJop0SVLFA
         9mbJenrotFkQ2omt8OcYsiqZgk8Rg4s1R4NyL+QQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221104120823epcas5p399e2f1cdfe17cf7739ffc5596fcf1da2~kYFpbNml42167721677epcas5p33;
        Fri,  4 Nov 2022 12:08:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N3fXg2xBKz4x9Q1; Fri,  4 Nov
        2022 12:08:19 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.47.01710.3B005636; Fri,  4 Nov 2022 21:08:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221104115841epcas5p490b99811e257b8f3f965748df0a57be5~kX9L24CNV0452004520epcas5p4L;
        Fri,  4 Nov 2022 11:58:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221104115841epsmtrp16a20ea5fcd96b608443f86f8ef70913d~kX9L0_1pw0158701587epsmtrp1S;
        Fri,  4 Nov 2022 11:58:41 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-49-636500b3a16b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.1D.14392.17EF4636; Fri,  4 Nov 2022 20:58:41 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104115839epsmtip269ad058ed8704ea923a10f84308abf0d~kX9JUtNFg2287922879epsmtip2T;
        Fri,  4 Nov 2022 11:58:38 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Jayati Sahu <jayati.sahu@samsung.com>
Subject: [PATCH 1/4] dt-bindings: net: Add EQoS compatible for FSD SoC
Date:   Fri,  4 Nov 2022 17:35:14 +0530
Message-Id: <20221104120517.77980-2-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221104120517.77980-1-sriranjani.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WTa1AbVRTHvdlkd8EJroDtJUCLy4gFBkg0hI3ycvpwfXRkqB8c7QCZsBOY
        JJtMNqmFaS1QgRLta6wtYuStNhFohYAIpSJQBArYao2ofVBCxqalD0kpVEsrIaDffufcc/7/
        OefeiyOBvagIz2eNjIFVaEjUn9/RH/1sXNtjjFJcNx9M3XcfBZTlx/f5VM3AuIByDU5h1MBI
        I4+6XH9LQB24dhWhznUcEFCtToeA+rnLglJmx7SAql5sFlCDtWuoe2dnAFXffhejHt1oB9TA
        6DWEKu0ZwKg/ZloE6UG03fobj3YdbMfob6suYXRtq4lutVWg9EXHKZRua9xD3z79C0ofsNsA
        /f1pCe1a6EFo+3ceQHta12UI31Yn5zGKXMYQwbBKXW4+q0ohX9uWvTE7USaWxEnkVBIZwSq0
        TAq56fWMuC35mqUxyYgdCo1pKZWh4DgyITXZoDMZmYg8HWdMIRl9rkYv1cdzCi1nYlXxLGN8
        QSIWP5e4VJijzhs9XyrQ/+63s9piA0WgETcDHIeEFM65Y8zAHw8kugEcvH4b8wWzAH7hcQNf
        cA/AQ71j2GrH300hvnwPgLX7exBfUMqDJc5y1Az8cJSIg6UOD897EEz8CuDVjyaWdRGiBIFn
        Pz++XBVEbIGjDgfPy3ziGVheP4l5WUikwC/HrAIvQ2I9/OpkL+K19iNSofV4qFcHEhM4/OYT
        N89Xswku2p18HwfB6z/YMR+LoPtg2QqrYNtA24qmBu4r2Yv4OA32XrDwvfoIEQ1PdCX40uHw
        45GWZXmECID7/5lesRLCzupVjoINUxUrHAabp2ZX5Gl4q+0h6tvKYQDnzN3oIbCu6n+LWgBs
        IITRc1oVwyXqJSzz7n+3ptRpW8HyU455pRNcmrwT3wd4OOgDEEfIYOFsh1IZKMxVFBQyBl22
        waRhuD6QuLS/w4joKaVu6S+wxmyJVC6WymQyqfx5mYRcK2yojFEGEiqFkVEzjJ4xrPbxcD9R
        ES+sLINuUv8ZXvdwYuSdraOdT3vSnvAPaID9WR8cGXeXvfWednvAhiaT0xoh6DoWNj/ELw6Z
        LNzlUEUG1FSORRsWRNasqigsvN4sz3gz9eXx+WBbTnpZVXFkV+fNMy8Zx8svYmm2oa8lat7a
        yDvu7U5ZaOax6a0vLhSqKtSPoipfdVrYIv+5AtK6O/3EyX0bMkXNGpffqSuxnL5bemX95qGG
        uoTJNcmDw83hNeVdtpGftjGoSfbG4mfy/uG9d+eP7k7MepDZEutRJ2XePH8kffPjFi5vWM3E
        aGZqL7v02r/uV13YGfqp3HXuQ/GunrBY+wPjmRs7iskn9WxSTkF7qqtyD8nn8hSSGMTAKf4F
        vHysC1MEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSvG7hv5Rkg87HyhY/X05jtJhzvoXF
        Yv6Rc6wWT489Yrc4cmoJk8W9Re9YLfpePGS2uLCtj9Vi0+NrrBaXd81hs+i69oTVYt7ftawW
        xxaIWXw7/YbRYtHWL+wW/19vZbQ4cuYFs0Xr3iPsFrffrGN1EPbYsvImk8fT/q3sHjtn3WX3
        WLCp1GPTqk42jzvX9rB5bF5S7/F+31U2j74tqxg9Du4z9Hj6Yy+zx5b9nxk9Pm+SC+CN4rJJ
        Sc3JLEst0rdL4Mo4c7GVteAWZ8W8OasYGxiXcHQxcnBICJhI/Foj2cXIxSEksJtRYveHv0xd
        jJxAcRmJkw+WMEPYwhIr/z1nhyhqZpJ4//gvO0iCTUBXovXaZyaQhIjAQ0aJ8587WUEcZoEu
        ZolXXTvA2oUF3CTOXLsGNpZFQFWifdEDsG5eAVuJ5WdXskKskJdYveEAM8hJnAJ2EitXSIOY
        QkAlc+drTGDkW8DIsIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzhqtDR3MG5f9UHv
        ECMTB+MhRgkOZiUR3k/bkpOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpa
        kFoEk2Xi4JRqYDpx2WSbk8rEt7nHmls8FSqmbGuOOhChuHj3lbWWVexxFhF1Esuub+z7vnv7
        dY8Gi2/f1QrnJL4w/DV/3bmUBcr1Mx6+C2KLLVgziUVjmuCU3CW7NZe/ee5hdck0LXfflUIV
        +QAls+LlHqWczgsLKrY5KpmIaaW/0PH5dvhjnUHAmyP8LLF19y3+9vK6zZf45HbEP+Be9LKn
        7zkk/qus+/hOge/wu/VnH+s2ncllFcpmmxXhf/Sm0LyUiH1yftpJRoasi/s3TD/rdjw+ejsD
        9ynJ3UmhmnbZO/QZHjAEZnCL6hj+3WirEK+tlx1esET44wu5BZ1yxQFL8267t7zTSZN8eDVM
        6OIhtaqjxw8dUWIpzkg01GIuKk4EAHqrtnoJAwAA
X-CMS-MailID: 20221104115841epcas5p490b99811e257b8f3f965748df0a57be5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115841epcas5p490b99811e257b8f3f965748df0a57be5
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115841epcas5p490b99811e257b8f3f965748df0a57be5@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add FSD Ethernet compatible in dt-bindings document

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e88a86623fce..2b0b9e5f3fa1 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -89,6 +89,7 @@ properties:
         - snps,dwmac-5.10a
         - snps,dwxgmac
         - snps,dwxgmac-2.10
+        - tesla,dwc-qos-ethernet-4.21
 
   reg:
     minItems: 1
-- 
2.17.1

