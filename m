Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDE76A64BE
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCABYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 20:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCABYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:24:05 -0500
X-Greylist: delayed 84 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Feb 2023 17:23:38 PST
Received: from alln-iport-2.cisco.com (alln-iport-2.cisco.com [173.37.142.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA3132CEA
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 17:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1067; q=dns/txt; s=iport;
  t=1677633818; x=1678843418;
  h=date:from:to:subject:message-id:mime-version;
  bh=FSMPhIpvsVLI3AMNFBkfDiSpYoc5kYfcE3Cas36F1hI=;
  b=HGrUcqNHUhNuCV165feFIG0Y1BbOxphRe7MCzrLJY9Mm1H9eg2dTvsZu
   GYTF7pk20/P9TfJ/6f0blqte2S7FNC0iMLlc6NSjaF8cWUnJ6Ie3nMdUV
   wBRKY34UpRtMsh4I/6tchVRdf3dHuMCq7Bq/q3skGDimfbcYlktD1n8iQ
   s=;
X-IPAS-Result: =?us-ascii?q?A0AYAADfp/5jmIQNJK1TBx0BAQEBCQESAQUFAUCBOwgBC?=
 =?us-ascii?q?wGECj+NN4wqjmuLOIF+DwEBAQ0BAUQEAQGKNgIlNAkOAQIEAQEBAQMCAwEBA?=
 =?us-ascii?q?QEBAQMBAQUBAQECAQcEFAEBAQEBAQEBHhkFDhAnhXWHFmiBFQGDEIMjA7B2e?=
 =?us-ascii?q?IE0gQGfWYFnJ4EZAYx8hFcbgUlEhgIBgymGVASVYWmBNHSBIw6BMwyBCQIJA?=
 =?us-ascii?q?hFvgRQIbIF7B0cCD4EJNwNEHUADC3U/NQYOIQZYdiUkBQMLFSpHBAgMKgUGR?=
 =?us-ascii?q?QkRAggPEg8sQwcHQjc0EwaBBgsOEQNQgUcEb4EaClObD4E6CoE5kx+QT59bh?=
 =?us-ascii?q?AOBVZ8ITBKpJpdZIKJJhQUCBAYFAhaBYjotgS4zGggbFYMjURkPjjcCk3Mjb?=
 =?us-ascii?q?AIHCwEBAwmISyuBUF4BAQ?=
IronPort-Data: A9a23:dg33OKu7q1ntzRvdMIetU5UPbefnVJteMUV32f8akzHdYApBsoF/q
 tZmKWCBMveCMzGneNtwYIm28RlUvZXVyYI1SQRuqngyEC9GgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0vrav67xZVF/fngqoDUUIYoAQgsA140IMsdoUg7wbVh2NQ42YPR7z6l4
 LseneWOYDdJ5BYsWo4kw/rrRMRH5amaVJsw5zTSVNgT1LPsvyB94KE3ecldG0DFrrx8RYZWc
 QpsIIaRpQs19z91Yj+sfy2SnkciGtY+NiDW4pZatjTLbhVq/kQPPqgH2PU0MmxdmhC5seJN8
 +5IqMHrbzUoN5STl7FIO/VYO3kW0axu8bvDJz20ttaeihSeNXDt2P5pSkoxOOX0+M4uXjoIr
 qJecWtLN0vZ7w616OrTpu1Eis0lLcTvI4o3sXB7xjafBvEjKXzGa/qTuIUJgGhs7ixINbHkW
 9YLYidOUDv/by9fIwxIKLU3kd790xETdBUB+A7K+sLb+VP7ygFt3LXzGMTad8bMRshPmEuc4
 GXc8AzRABYTPsaS1BKe43SrnvTehmXwX4d6PLS8++5jhlGJyyoPDwcZSFaTr/6ikQilR5RUL
 El80jIjtbA/skeiUND5WxSip1afolgXXN84LgEhwAiJzqyR6AGDCy1dFnhKaccts4k9QjlCO
 kK1c83BXhdloZilZ0ChzYyRsG7pHxoUJFZdanpRJeca2OXLrIY2hxPJa99sFq+pk9H4cQ0cJ
 RjX8kDSYJ1O0aY2O7WHEUPv2Gn098KZJuIhzkCGADz5s18RiJuNPdTwgWU3+8qsO2pworOpl
 XwAls72AAsmUszVzHblrAng4NiUCxutOTnYhxtkGIMssm31vXWiZotXpjp5IS+F0/romxe0O
 yc/WisIu/e/2UdGi4csPepd7OxxlsDd+SzNDKy8Uza3SsEZmPW71C9vf1WM+GvmjVIhl6oyU
 b/CL5nzUy5LUfg/kmTuLwv47VPN7n1urY80bc2lpylLLZLFDJJoYe5faQDXPrxRAF2s/1mFm
 zqgCyd640wPDLKhCsUm2YUSNlsNZWMqHoz7rtc/SwJwClQOJY3VMNeImelJU9U8x8x9z76Ul
 lnjARUw4ASk2hX6xfCiNyoLhEXHB8gv9BrW/EUEYD6V5pTUSdvztPtFKsFqINHKNoVLlJZJc
 hXMQO3Yatwnd9gN0211gUXVxGC6SCmWuA==
IronPort-HdrOrdr: A9a23:47ChCKEhcahKsGJLpLqE+8eALOsnbusQ8zAXPmRKOH9om62j9/
 xG885w6faZslsssRIb+OxoWpPvfZq0z/ccirX5Vo3MYOCJggeVxEUI1/qG/9UmcBeOlNJg6Q
 ==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.98,223,1673913600"; 
   d="scan'208";a="71529474"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 01 Mar 2023 01:20:47 +0000
Received: from zorba ([10.25.131.59])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 3211KiGN019516
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 1 Mar 2023 01:20:46 GMT
Date:   Tue, 28 Feb 2023 17:20:14 -0800
From:   Daniel Walker <danielwa@cisco.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: stmmac driver RX stuck on "Unavailable Rx buf"
Message-ID: <20230301012014.GX15751@zorba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Outbound-SMTP-Client: 10.25.131.59, [10.25.131.59]
X-Outbound-Node: alln-core-10.cisco.com
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIMWL_WL_MED,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

We use the stmmac driver for some of our products. During testing we found that
with 500mbps into the port connected to the driver the RX side hangs until we
ifconfig up/down the interface. This happens on multiple kernel version v5.4 and v5.15

With debugging enabled this message was printed a number of times,

[ 4112.847415] dwmac_dma_interrupt: [CSR5: 0x00690415]
[ 4112.847422] - TX (Suspended): Tx Buff Underflow or an unavailable Transmit descriptor
[ 4112.847424] - RX (Suspended): Unavailable Rx buf
[ 4112.847415] dwmac_dma_interrupt: [CSR5: 0x00690415]
[ 4112.847422] - TX (Suspended): Tx Buff Underflow or an unavailable Transmit descriptor
[ 4112.847424] - RX (Suspended): Unavailable Rx buf

We see the status from the RX side claims "Unavailable Rx buf". The documentation I have
doesn't describe what this status means.

Do any of you have experience with this RX status? I thought this might be a missing DTS
option since stmmac has many, but I figured I would ask the maintainers first before trial
and error.

Daniel
