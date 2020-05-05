Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A79E1C503C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgEEI1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:27:12 -0400
Received: from mout.web.de ([212.227.17.12]:52083 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgEEI1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588667214;
        bh=Ok1OkmTb86WegBkYIFRuRBWfLF8p2nKOY6hZlm1thOU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=DDa54gLkoGsSr/FQ0Uqtn9PeyGl43UV1l/ebdMxdQ1vtVWU4MyvR8nngyaN/oVto+
         yUBwxYLvE52nIOMCVJkPcA9uAnVrUKGa14s6sG2aq9tlXoTnWr+kT2cvgT0rZoYKp+
         xok1C2wVTU7DL8Ip/XDb9XMm6XxtApbuM6iwqZpU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.132.123]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M40zO-1jF2YG0Hxq-00rX4E; Tue, 05
 May 2020 10:26:54 +0200
Subject: Re: [v3] nfp: abm: Fix incomplete release of system resources in
 nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, oss-drivers@netronome.com,
        Kangjie Lu <kjlu@umn.edu>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200503204932.11167-1-wu000273@umn.edu>
 <20200504100300.28438c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMV6ehFC=efyD81rtNRcWW9gbiD4t6z4G2TkLk7WqLS+Qg9X-Q@mail.gmail.com>
 <ca694a38-14c5-bb9e-c140-52a6d847017b@web.de>
 <CAMV6ehE=GXooHwG1TQ-LZqpepceAudX=P63o139UgKG7TMRxwQ@mail.gmail.com>
 <6f0e483f-95d8-e30b-6688-e7c3fa6051c4@web.de>
 <CAMV6ehEP-X+5bXj6VXMpZCPkr6YZWsB0Z_sTBxFxNpwa6D0Z0Q@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <956f4891-e85d-abfd-0177-2a175bf51357@web.de>
Date:   Tue, 5 May 2020 10:26:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAMV6ehEP-X+5bXj6VXMpZCPkr6YZWsB0Z_sTBxFxNpwa6D0Z0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HphUrIpWfwZjrPoTG1Dqn5X9jxs57+XUIA6eUXzcr3DAHLGea5P
 T5EexcuC81R5JLTrRPEPO756a5a9xvyoSKtLfdaC3MTkB5TOZ0fCAtS4uPzKMsxG3YlqICW
 W0SKf4E1mhglHnKgH9LZVFScE1v0fBlLFTnv+56tNNxYPc7c4zSSL0X1D7lE1k6kHB7e2LD
 7usFbdfVMWCgw8XiN+LnQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2XHervG/tFA=:Gee9u4tA8rZPxYaCgomwMD
 4QgFbRhy5l4cS4at0dCssiWYJSgQOl4cHRfistivZpyiiqhNlCh2vdwZSj2Tq8ZkxldKl2ft8
 TH0uWbU6Lma/7yfMuxWh6HtdEu9IVhYBYGKYwywxYXkKWltqoHPzZVfT6PkOoYtQ26WCOPMmf
 ognIjpJvREHN1mcsvXcpJXTkXKJZsoWwzvDCuDNxmNvRxQ4KG2upmQO1kFMnBsZ7s8PDE+99t
 f1wpC+Z1RQvxlmDRss2EO6ER3IgNTSJ/SQIcanT5zln0xx08LHExL/ANbkPXRKhglJg2VTZiw
 xREgwtmslkaFDNvvW0sOQNX1UoTazs9WnvPmvlK8EPWwlJKF++QOjVqQfFgqm433DP+2yqwCf
 LOvVILj2bExTGQ4X87vueyFaHhWZAJ8+dIWsXSLrO8eqh7yIy+cGWxRXzDZN7Td2xSdXEBfgr
 HOV5+jxt8XWqceF4y+odsWC3qXiFlqJoGO0VxTCrChkgcVWFo7ooAEMGe6cvkG4TmDx6jdgQa
 dGA0FrC064sUwngfvQWazqhszwYs8cz8XXmjcIly4uwS5wftQh3hiCc6DyCtaHvE6A+vWZxVk
 4oQVPg4NZe7mYCDxQmIMpisW6xSjapzaZgtISkFw49ietJK4ashKipgAH44Is1vWHgrBhzAVc
 0LHL0RymH6exPcs2p7fR+MIOaL4N7OuliyrvqB4lNXbqV2kYxrrDdqj3duQyPu0l0A1PkwYj2
 hHvArDBWy4fGbj8iC0QaiMp6wQ4a8wkG6ONz0nYt+HJtl00npqKN1bo7ZDtS7fvbAcLqIm55A
 RwaipWRNPeyKKLg/c70pf+Z6oXS1m3K1sF+aQM07CB/Wk8bVSOG76DvVsMz1Nz+Z/6VyhVPDe
 rpa85wdMFfIe05ju/GfHQsTBlL29G6spEhHrVcUQayH/GjhLW0/wL27qL4qFtNDdJIXhzfXf5
 LQgImQfaRB7S03yHngtglW0iko8Lldla0WRpkENwcE21REbWSt+/QY59vVI2fxg40ztRWWJ+d
 teduEaMHMDMfLyfTr+ps5EAaa3tUowJXS4JPhFgJFIDRucuFvgOCsCcsF/qhJXN517UKTSqx6
 nGLRGTwwTxnR6dTD2NIpsttCdUva9CxTFMUFwBatdJqegDiqRs+divdF3DK5LqFCV574nVPmt
 fz8utMIWlULwIrTMdsbg+g8NvgNiGwbZfoYS58PmqoGIzN6Zm19hqWkHWfakBXRU3BR4OdYKl
 tyKrx0CPratvjUjc9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>=C2=A0Do you distinguish between releasing items and the role of such a =
pointer?
> I didn't distinguish these.=C2=A0

How do you think about to clarify this aspect a bit more (according to com=
puter science)
besides your subsequent constructive feedback?

Regards,
Markus
