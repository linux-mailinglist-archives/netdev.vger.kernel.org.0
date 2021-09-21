Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE58412F73
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhIUHbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:31:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56508 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230105AbhIUHbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 03:31:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632209384; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=kKdhD4lzVyFP69pBm3weZQlw0bDreWRpvFnA2JACO6A=; b=HQ7oXllr0amf8d9veQtrLAkb+z1dYNeZ/xZ63XugP/LkRvad9fxhMwnhWPaqmGdOO+bAoled
 RSYKstoy9akKj1DDTkAD9E1kw95yFji2YQ9ZDYgvSlM6h2cQL29QA6xGKfEAQdNm/P4mzY1R
 J8wPxsaoRO6oD4itOmSp5TmBtCE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 614989e5507800c880f997d9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 07:29:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 91B12C43618; Tue, 21 Sep 2021 07:29:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E18BC4338F;
        Tue, 21 Sep 2021 07:29:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0E18BC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "sparks71\@gmx.de" <sparks71@gmx.de>
Cc:     ojab // <ojab@ojab.ru>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
References: <20210722193459.7474-1-ojab@ojab.ru>
        <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
        <CAKzrAgQgsN6=Cu4SvjSSFoJOqAkU2t8cjt7sgEsJdNhvM8f7jg@mail.gmail.com>
        <CAKzrAgSEiq-qOgetzryaE3JyBUe3URYjr=Fn0kz9sF7ZryQ5pA@mail.gmail.com>
        <538825a2-82f0-6102-01da-6e0385e53cf5@gmx.de>
Date:   Tue, 21 Sep 2021 10:29:34 +0300
In-Reply-To: <538825a2-82f0-6102-01da-6e0385e53cf5@gmx.de> (sparks's message
        of "Sat, 18 Sep 2021 12:12:23 +0200")
Message-ID: <87wnnav129.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"sparks71@gmx.de" <sparks71@gmx.de> writes:

> Have you seen the new patch?
>
> https://www.mail-archive.com/ath10k@lists.infradead.org/msg13784.html
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=973de582639a1e45276e4e3e2f3c2d82a04ad0a6
>
>
> could probably have been communicated better

Yeah, apparently there are two different fixes now. I'll review both of
them and try to choose which one to take.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
