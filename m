Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D2746FDE5
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhLJJjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhLJJjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:39:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AEFC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:35:58 -0800 (PST)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639128955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBYC6INRj8oAA6ylOY7yTpCGQBsmhCEkH4H9/SmuxZY=;
        b=rrRR1owdCdOZDPHB8ylGip3CoJNyq1v1ksRu15cNU9meoa/aJTgQ28bHDgJ5qD2Z6PbYA3
        GVaNasRjnz6kHOaWCYxTu9veTNDvtqiUM8To0r2ug44gKPjpo3IhqvU99ByDbKZSnypdQz
        YC3QGoqsiH6qoXrGzcrjrJ3N4vGSJRIDTK+P/O4Bo9iLEc8Yzs8fWeQy7ZhUCZTTVI7bSA
        E9Q2Am/63kRhUt8Qk6uuyNrSCaLDjCOOzf+7OdH9y4w708fWXlImDNZmtaJ5+hR/B/cOFR
        uiHDEp2Tgy4UDaHML0C760iETnUaG/t+dfa/RVkxMWJ5RyZCSnX14VaEVNLM1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639128955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBYC6INRj8oAA6ylOY7yTpCGQBsmhCEkH4H9/SmuxZY=;
        b=JKa3Ohp4lxLVvxXIDyehXNOqJTZR8GOVgHA3+FqUTWTL8oB4lxsSAXYX7P6ApEcZrmDkIz
        hYMSrdMebd4akiBg==
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
In-Reply-To: <20211209151631.138326-3-boon.leong.ong@intel.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-3-boon.leong.ong@intel.com>
Date:   Fri, 10 Dec 2021 10:35:54 +0100
Message-ID: <87ilvwzts5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi BL,

On Thu Dec 09 2021, Ong Boon Leong wrote:
> This patch adds basic support for EtherType RX frame steering for
> LLDP and PTP using the hardware offload capabilities.

Maybe add an example here for users?

|tc filter add dev eno1 parent ffff: protocol 0x88f7 flower hw_tc 4
|tc filter add dev eno1 parent ffff: protocol 0x88cc flower hw_tc 4

>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Something is not quite correct. The use of the etype variable generates
new warnings. For instance:

|drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:768:25: warning: restricted __be16 degrades to integer
|drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:768:25: warning: restricted __be16 degrades to integer
|drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:817:22: warning: restricted __be16 degrades to integer
|drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:817:22: warning: restricted __be16 degrades to integer

However, the steering works as expected. Thanks!

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGzH3oeHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEHkqW4HLmPCmtiEP/2Bi/cOq//6urSTu
9iDsESTq1pnJFcfbykRsCaonY7bjzFZN/suxxUC4IZom/4kzhE9lJSPxaQUo+xqD
/MLbehxqfA6VZ1HWWngVTxKcUhUhNdkw9R6zSkHXPdbTe6D3Q/ml/PoYMrNczR1W
68u7Tl8khf6IQWRvZAinAvsgTSSkr4gCvmkcSDVCZ2tf9TvitdQILGr9DkCyK7mk
8bXFWPFRB4Hmd2Mf09uGagpQxrRcqaIjf4AGgI1PedXFWEJ89mUeX+Czr4yM0tYb
52j8QxTQpqAiJ9QXvATIY/wZqwalHc86EvFwZCAALpv7rPw96rvUrFGSsIqxMn0a
NWPVHqvnr/rXPSA+3aiqrXFhUsKdVSk7/azOsElXcwPEkLH1G74ORYSp/gWIu/7u
kNUhKHaftCvFHxZ9IqQySzkjl95dfomsbwuhmhJ1mxtSKiV/npcYsz6JwHxNn/y5
BNBjmjVJ5Jj9bSgBlIRT7WlghNjrWWghPjRlt2vulnqMDeDfZeCCCgbyaAmwJn/K
kVXIuByOtNTAfomUpv5dITVPCIBAreozXDAr4YGUF7u21ZWiCyXKKImNJXRt66IM
3bv4sK05YdleYhcL/z6IaKzzKr5yH3RRTcDWqeRUxsWomjpmJ1zVE59vr+5zQZKs
2j/rBVvZGry982hd7ll9/Uq3FkFC
=6esP
-----END PGP SIGNATURE-----
--=-=-=--
