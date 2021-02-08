Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94308312AB8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBHGbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:31:20 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:47775 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhBHGaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:30:10 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id DC4A4580219;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=A0MotY/oB5vQ6s3LwI/wq+/t1E
        JXxwjHD9hCvZwPy3M=; b=TbEH4tEqFzjbSB55Gcv6A1JpeK9Rd+PRH3ME3Z/YQP
        n9Jlgep7cjdvIlyupcLjgkfTrBGQzIpGd0jrAjGtFMERSqL+baQGrBraN30y8u7I
        1lLEFJkYQo3pZegZ/UjKFOATT2dptgfdWJ6ssOIQxGmLCD4Kqc8SFoxRRqWVgLvg
        TJ4g3QYAupg4m7vojGl8OCHkUqJ3alxMq1LKCPPukwp55i8G/KUMq0JZc0qIVhdQ
        G8fBDVcqFsqMwmj4fUSv+RsjpX60QsdzIQV6ipVdAh570E6ZIV9nvvuqZmU7kSH3
        wWaFL6d52VCOFCP9n1wy4mkOfz3Bspz9EjRSzRNf+YlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A0MotY/oB5vQ6s3Lw
        I/wq+/t1EJXxwjHD9hCvZwPy3M=; b=p+sIQpUejjsOR+UZXaBjLHhgwe27v/xIZ
        nAKXKwbHJygp8YAoKreub+fS2A2SvYOC7+K95T4sNRHC36FaSxy4yXvpMYTscYlm
        1GB2OY5+f4abh18vPQiOc1oTDjSI+GjRpyUz936j4wMVEZ6lG+dqEmOTv5hIPuvY
        HxKR+2+TLaKgwtu0J6Kfia+pwaY8zQNc+ncjG+1uvJ+Tb4bRrh/A+22cr48FSBPa
        dfo7v6KEL7iMeEqh6GqIoRYjbI/AgN2HXZzvs6oUrC4nDet+sly4mVCDw7W2s+39
        LAcMVPAkvQugC2qsAPUVANVkztFssUWCfasd1sPCug0NUZAv/5Muw==
X-ME-Sender: <xms:LNogYHG3u25YDLp4_-NQnGhyo4LfSGwkycaqGHZgXfownIhXgAu7VQ>
    <xme:LNogYEW93i4big21XN4vEBOfij_kfL4mYtzxBCWDwSvZkYwoSdCci-NWA_f69KACp
    g7OvDeYFE76-8B_Ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrfgrth
    htvghrnhepieetkefhheduudfgledtudefjeejfeegveehkeeufffhhfejkeehiefftdev
    tdevnecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdho
    rhhg
X-ME-Proxy: <xmx:LNogYJLs3lvpSCHQ295AW8a_Yep1aIgtrUsgfjlxSU6Z-6F-VKkaIg>
    <xmx:LNogYFFS8V2Mnu_McbbeMczqZbw3V6LDw9_2P3PU1OLAJWZTUkWVNg>
    <xmx:LNogYNWWpCxzfnrwqBq4IaF_2dLK7TSPtFSd5RONbcXQ7BHFe7T8wA>
    <xmx:L9ogYGuJJDEiCvuKtZfVzCNAZA-KAt2iMv3SLuO9mZ83G_lWVF8QwQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5110B108005B;
        Mon,  8 Feb 2021 01:29:00 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>
Subject: [PATCH net-next RESEND 0/5] dwmac-sun8i cleanup and shutdown hook
Date:   Mon,  8 Feb 2021 00:28:53 -0600
Message-Id: <20210208062859.11429-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches clean up some things I noticed while fixing suspend/resume
behavior. The first four are minor code improvements. The last one adds
a shutdown hook to minimize power consumption on boards without a PMIC.

Now that the fixes series is merged, I'm resending this series rebased
on top of net-next and with Chen-Yu's Reviewed-by tags.

Samuel Holland (5):
  net: stmmac: dwmac-sun8i: Return void from PHY unpower
  net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
  net: stmmac: dwmac-sun8i: Use reset_control_reset
  net: stmmac: dwmac-sun8i: Minor probe function cleanup
  net: stmmac: dwmac-sun8i: Add a shutdown callback

 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

-- 
2.26.2

