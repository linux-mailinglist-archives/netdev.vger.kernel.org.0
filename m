Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993CF52D7E9
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241147AbiESPie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241288AbiESPiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:38:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D593F134E;
        Thu, 19 May 2022 08:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 566CAB82567;
        Thu, 19 May 2022 15:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D965C385AA;
        Thu, 19 May 2022 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652974646;
        bh=aAtk0AWz5blwGH/xbY2AZCKKKj5atoROs7ScmIJsrOA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BSNGYMURKhzbRfYy3fPbyDRgLaysOagNKV26sKM44XzSnTQfxxozioFUtTrFkDthd
         Wtf/EAPVvsCwYn9WK8Csu2xyMtHpRKhBZy7CPXOACCFivxn+3fOthkWJf/8RDS4Xyp
         eObEXJMJZ7qu0m0J7THkNS5kIfxCkLTatyvqhx9eSMu3cDvaPAlwVzg4VvGVFFELrg
         Myybjonz21ju/df1hEZ01bdx1TIdDXMYSRoV7v8OR43X6+rq5f81N6KasTWB4b5rWk
         A0OxFhgo9Gp4dHRaBZMqXuQwuB4t19lcyND5QoDKHSabNuBnljy1J3z804nclRXo1P
         81Ju9PWhtdKRg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Yongzhi Liu <lyz_cs@pku.edu.cn>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fuyq@stu.pku.edu.cn
Subject: Re: [PATCH] mwifiex:  Fix potential dereference of NULL pointer
References: <1652957839-127949-1-git-send-email-lyz_cs@pku.edu.cn>
Date:   Thu, 19 May 2022 18:37:19 +0300
In-Reply-To: <1652957839-127949-1-git-send-email-lyz_cs@pku.edu.cn> (Yongzhi
        Liu's message of "Thu, 19 May 2022 03:57:19 -0700")
Message-ID: <87r14p1qkw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yongzhi Liu <lyz_cs@pku.edu.cn> writes:

> If 'card' is not valid, then we need to check the
> field 'adapter' and 'priv_num' to avoid use of NULL
> pointer in function 'mwifiex_get_priv'. Fix this by
> adding the null pointer check on them.

Why? We don't add null checks for every access, why does this function
need it?

How did you find this? Is this something you found with a static checker
tool or by testing with a real device?

> Fixes: 21c5c83ce ("mwifiex: support sysfs initiated device coredump")

Format is wrong, it should be:

Fixes: 21c5c83ce833 ("mwifiex: support sysfs initiated device coredump")

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
