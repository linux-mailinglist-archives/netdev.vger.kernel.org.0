Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFAE5B80F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfGAJcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:32:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44103 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728143AbfGAJcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:32:16 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id D6AE721B74;
        Mon,  1 Jul 2019 05:32:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Mon, 01 Jul 2019 05:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:references:date:in-reply-to:message-id
        :mime-version:content-type:content-transfer-encoding; s=fm3; bh=
        IJ6GUF7j7DADCe5/F/QbGL7vG/nLvnbwXu0sHIZ4W0k=; b=WtV7ljixw77ez3eE
        96CcMOfDGZ0j5TJM8lEz5w7Vr5iWIWb/i5h3s+jLMZLC2zTWQU3lw3nj1/B3GyCh
        kTD6KX+YwIrmRKlkxVDLPUedVSGSUqQkevO0SziEpKqnuHx3sGjnqC1SYibz2HjB
        lpB9IyRn+UfVHb4OLdkQqC+VqtjMyVlCZs+Z1TaUlqJWhc8G9TSxBiE84aE3yfqj
        MJ83mDWqhtOvsSW45EOI7/mgbNZOZoYOrPkYGNPOyEBEpgwjOBU5u/9f5mDfagVn
        tY0EIc+E+06bmzJfrMhbZrKNdoIHGvRXTqz9j3fn225LcgWobUvicuAj7dL35+w/
        UV+bFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=IJ6GUF7j7DADCe5/F/QbGL7vG/nLvnbwXu0sHIZ4W
        0k=; b=T8ivQKDGge0Gzj69G8SsWl5TLUhSbS8f+uKfz3rbVjOJnutCuPbmFA9IU
        mqgZLk9eqqZCtTf3WU2ggw1mL0+a4akM4R39rxD0u2Fyi1eAXF1GqtW9nmbRMTV/
        2xqh1x8bMCaMDtBMB4eO8EOf/UazlvrbjOuy/QLwB7WgK6om25Al38T1rSF910e/
        ptpnqbIaydCcuFgqczJmLyx0PCTHIT9Nu8+9WYwXizEOToc9gU1X6Cf6KJCUl6uZ
        tu3WslJxF8+foqRXyKEwjbqhEpr3/Jm/qRxppAxYL1oEbmTm/sbK4w0vfQ6Rj4ue
        cdGjcjXNefG1Gft86pILd7LQDboFw==
X-ME-Sender: <xms:HtMZXRzhK448ag7Ec5Yf-Y0KtX_m8_wtZPJpJgIxoMiYHee8x9lL4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufhffjgfkfgggtgfgsehtkeertddtreejnecuhfhrohhmpeggihhntggv
    nhhtuceuvghrnhgrthcuoehvihhntggvnhhtsegsvghrnhgrthdrtghhqeenucfkphepke
    ehrddurddutddvrddvfedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvihhntggvnhht
    segsvghrnhgrthdrtghhnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HtMZXUUCM_NbyZ9hxXvKp8Mo7pbmHCko7yegz1pskqueirL2sRs8iQ>
    <xmx:HtMZXV_Ne6o3vCvQwYR7LfbxytRZUPvk2kif2jRi18xIHSq4Vq-Q5Q>
    <xmx:HtMZXftC0F827ibX6mITsuuCsK3ljlGiVCkd_J7e3wwvjmi6Pg9guQ>
    <xmx:HtMZXS1tqHLj9fa4H7EtUd_1WVJwYJlcG04316puAQYtUIkNcj4t4Q>
Received: from neo.luffy.cx (230.102.1.85.dynamic.wline.res.cust.swisscom.ch [85.1.102.230])
        by mail.messagingengine.com (Postfix) with ESMTPA id D029480060;
        Mon,  1 Jul 2019 05:32:13 -0400 (EDT)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 3330C10FB; Mon,  1 Jul 2019 11:32:12 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] bonding: add an option to specify a delay between peer notifications
References: <20190630185931.18746-1-vincent@bernat.ch>
        <20190701092758.GA2250@nanopsycho>
Date:   Mon, 01 Jul 2019 11:32:12 +0200
In-Reply-To: <20190701092758.GA2250@nanopsycho> (Jiri Pirko's message of "Mon,
        1 Jul 2019 11:27:58 +0200")
Message-ID: <m3h886f6cj.fsf@bernat.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 ❦  1 juillet 2019 11:27 +02, Jiri Pirko <jiri@resnulli.us>:

>>+module_param(peer_notif_delay, int, 0);
>>+MODULE_PARM_DESC(peer_notif_delay, "Delay between each peer notification on "
>>+				   "failover event, in milliseconds");
>
> No module options please. Use netlink. See bond_changelink() function.

It's also present in the patch. I'll do a v2 removing the ability to set
the default value through a module parameter.
-- 
Don't patch bad code - rewrite it.
            - The Elements of Programming Style (Kernighan & Plauger)
