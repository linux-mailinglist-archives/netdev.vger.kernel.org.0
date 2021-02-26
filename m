Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E76326A25
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBZWmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:42:42 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:59495 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhBZWml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 17:42:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 00B61A64;
        Fri, 26 Feb 2021 17:41:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 26 Feb 2021 17:41:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        content-type:mime-version:content-transfer-encoding:in-reply-to
        :references:subject:from:to:date:message-id; s=fm2; bh=/AojvGHiu
        KCihZREfOyE8ufy/JDdlBOYiie+mgFJl/c=; b=h6TBLldKuT+6kNcAChN0gzLHf
        S0H55yC+qtEtlCKXdE30hdZw3bfmbWgBT9ZAm80kch03cH2lCmnZGMPb7ul1OgV6
        wv3moI4ZNYeMk2YgVq+qzOLMFiPHvuTvhqJifgtNShaLb6+AZ5DznDwh8y9R2JAC
        e6wiS+r09HAdg/L7pnXSlvS99bwup56a+cK2TF8HF3EO70dRJ8AW5HtJfOb47+Jx
        ZrvSjCzuGFWNEqtmEo+CuWE9B+OhiqWVuAOZz9a901kRvGzXyPMW7O/LlVbcTx75
        +8l2GlmcOXFGsJwLUKkGdqwgzH6mcIngKcDTqMJkG1OMznApljAmiFkmLygLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=/AojvGHiuKCihZREfOyE8ufy/JDdlBOYiie+mgFJl
        /c=; b=rMcxlW+irwwomCcw/LghnSx8gvG6I4xhZyVPm2XzBp5dYs9nqfHCtBTJS
        0PPpzmuoRA2PnXHArMfhh9bOyCDLjx+dezEFFWDv32suMUyHJkYeotLcbuHCIKUS
        lgCoOuQ1isFq0YTnDbw9OjAzg696wahhTpHkzJy5/DF6r1q5Qvh/lAJZLAfUmSrm
        Yerh1xA9riwampvJl+8DNcnC8VzE4adfaAEI3pDFwLlZ7MpgAqpAW8UVL/cuDEDD
        R4f/RezuQeFZd1vdmIqZOlUEK9GZVa77Hhiajqjk3Swn0PrAeq45lJDz4qfXkC4S
        lIZhNBsUjjeV9rvsJ285blmVRtQ2Q==
X-ME-Sender: <xms:HHk5YNu2KfpbqeuRTM1KsngS8utMfP7YQJ1kXsV1x0HNNV9Y4y8iiw>
    <xme:HHk5YGe55cEZlqvYl3gCCxravMkhCkB94UVamPm0JxDTMF1dCT_TFNJdrhYcckNBO
    TvfMKK1oUJIInxfZgM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrledvgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpegtggfgjghfuffhvfffkfgfsehtqhertddtreejnecuhfhrohhmpefkrghnucff
    vghnhhgrrhguthcuoehirghnseiivghnhhgrtghkrdhnvghtqeenucggtffrrghtthgvrh
    hnpeejueffgeehtddthfdvkeeifeeivdevgfeffeejudfgvdefffffhfeludevffegueen
    ucfkphepuddttddrtddrfeejrddvvddunecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihgrnhesiigvnhhhrggtkhdrnhgvth
X-ME-Proxy: <xmx:HHk5YAzTtieX0iMKWxTYL00NdzalKcw1x3vrU-rmuenUetYxrhxN9w>
    <xmx:HHk5YEMQaGaU-8AnhJIbvy_Kzto8Bt0Jwh_M1VSLEcNDE5ovEbSoYA>
    <xmx:HHk5YN_i8mwaFzryPGu6Xj2UlMR4M4wBscT1cgHwAsaDvE8t7r8Tng>
    <xmx:HHk5YPnAieeN0sk-0-7g7rjHrIlhJdENixhPeDRxLqU-8Qed0OtsTw>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 100741080063;
        Fri, 26 Feb 2021 17:41:32 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <251d8abe-04ff-a49e-d818-cc7b6ba5e647@iogearbox.net>
References: <cover.1614201868.git.ian@zenhack.net> <251d8abe-04ff-a49e-d818-cc7b6ba5e647@iogearbox.net>
Subject: Re: [PATCH 0/2] More strict error checking in bpf_asm (v3).
From:   Ian Denhardt <ian@zenhack.net>
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 26 Feb 2021 17:41:38 -0500
Message-ID: <161437929829.9937.12403986557577716638@localhost.localdomain>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Daniel Borkmann (2021-02-26 17:00:58)

> Applied, thanks!

You're welcome!
