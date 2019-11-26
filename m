Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE58E10A195
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 16:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfKZPzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 10:55:05 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:59668
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728295AbfKZPzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 10:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574783704;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=QB5TQ9oDmYa9bXkzj5ib42eAk5p+sdsbeXrhhHE1o4I=;
        b=XdBQHbZmU9/S9UPTkfS81KDCicSmfKfWrq896a7NVUs64qhuYqmg4tlVck4TwA37
        lmXoJ+TVd6wv+oVJFHqZbnvc59H9G4UkR6/qVhMcx+ELnmwep6F80A3OlUMatlcBfAG
        pWIg68/Q3cIW3VNpBqfHgKD3WbOLG5lElZQqPGpA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574783704;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=QB5TQ9oDmYa9bXkzj5ib42eAk5p+sdsbeXrhhHE1o4I=;
        b=FcRzjlwPJRR1w4VZVwQZ+sUzEAmW300J1wleBxCPqzGjlri878BLIjRTxQlODpeO
        g6O6yhkekTYDEieVm8p5+UEdue/2GrgzmBq7SsmSB1USm5JCXx9IhStqxUjL5JO3/KL
        vDDPZCkWfskkPxbiN9BlUqBLtiXb9UiJw/QTPYuw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 88F26C4479F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Stefan_B=C3=BChler?= 
        <stefan.buehler@tik.uni-stuttgart.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stefan =?utf-8?Q?B=C3=BChler?= <source@stbuehler.de>
Subject: Re: [PATCH] cfg80211: fix double-free after changing network namespace
References: <20191126100543.782023-1-stefan.buehler@tik.uni-stuttgart.de>
        <dfdb5abc-0565-f19d-bb74-df42c0e0224e@tik.uni-stuttgart.de>
Date:   Tue, 26 Nov 2019 15:55:04 +0000
In-Reply-To: <dfdb5abc-0565-f19d-bb74-df42c0e0224e@tik.uni-stuttgart.de>
        ("Stefan \=\?utf-8\?Q\?B\=C3\=BChler\=22's\?\= message of "Tue, 26 Nov 2019 11:12:30
 +0100")
Message-ID: <0101016ea86c5dc7-acc41db5-21f0-4fdc-81a2-f3c500c506a7-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SES-Outgoing: 2019.11.26-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Stefan B=C3=BChler" <stefan.buehler@tik.uni-stuttgart.de> writes:

> I'd also like to see this backported to stable, but
> submitting-patches.rst says you don't like individual developers adding
> the tag :)

BTW, that rule only applies with net and net-next trees. With wireless
trees we are happy to have the stable tag in the commit itself.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
