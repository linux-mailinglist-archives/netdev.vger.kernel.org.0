Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368704EEC7C
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345545AbiDALpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiDALpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:45:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39E43A5DD;
        Fri,  1 Apr 2022 04:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 583F6B824B1;
        Fri,  1 Apr 2022 11:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DDDC340F2;
        Fri,  1 Apr 2022 11:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648813412;
        bh=9b2hrUOXZUT4PtJ74mv2OEiQ6y7RhlwtuoDd+ejgaHI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=p2wSzyrF0VBZw1zFe1IbnVN7qphAnFNPX8ag1U5Qc5lBrI9JpRxpzJiMU+21SfuC0
         e27digsEly0p7uLDQZrbnshD5m9zC367HP5izc1WZ+N82FtkX1/rvLNGXOUntpS6Vm
         i4YAImYwXujxOOl/niepyVgbxLMHxFW5w8d94WyDxXlaPKrSaBnQP8QhUmA3nL9c/X
         U3U1Y39LDDq8RniNgJkd/iWi7WTo9lIPEHR26CguHEgWTgIk8PUSaX62eJayZOPSEI
         ipZxOIhpAVRHbXeS1fMjTtRJxSWCsEik/BoRGVIowLf90o4bX8SZ6UpfLTjt1+8E0E
         SWhT3rpqq5A1w==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iwlwifi: fw: Replace zero-length arrays with flexible-array members
References: <20220216195015.GA904148@embeddedor>
        <202202161235.2FB20E6A5@keescook>
        <20220326003843.GA2602091@embeddedor> <871qym1vck.fsf@kernel.org>
        <4c520e2e-d1a5-6d2b-3ef1-b891d7946c01@embeddedor.com>
Date:   Fri, 01 Apr 2022 14:43:26 +0300
In-Reply-To: <4c520e2e-d1a5-6d2b-3ef1-b891d7946c01@embeddedor.com> (Gustavo A.
        R. Silva's message of "Mon, 28 Mar 2022 01:23:59 -0500")
Message-ID: <871qyhuizl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> On 3/28/22 00:47, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>>
>>> On Wed, Feb 16, 2022 at 12:35:14PM -0800, Kees Cook wrote:
>>>> On Wed, Feb 16, 2022 at 01:50:15PM -0600, Gustavo A. R. Silva wrote:
>>>>> There is a regular need in the kernel to provide a way to declare
>>>>> having a dynamically sized set of trailing elements in a structure.
>>>>> Kernel code should always use =E2=80=9Cflexible array members=E2=80=
=9D[1] for these
>>>>> cases. The older style of one-element or zero-length arrays should
>>>>> no longer be used[2].
>>>>>
>>>>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>>>>> [2]
>>>>> https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-le=
ngth-and-one-element-arrays
>>>>>
>>>>> Link: https://github.com/KSPP/linux/issues/78
>>>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>>>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>
>>> Hi all,
>>>
>>> Friendly ping: can someone take this, please?
>>>
>>> ...I can take this in my -next tree in the meantime.
>>
>> Like we have discussed before, please don't take any wireless patches to
>> your tree. The conflicts just cause more work of us.
>
> Sure thing. I just removed it from my tree.
>
> I didn't get any reply from wireless people in more than a month, and
> that's why I temporarily took it in my tree so it doesn't get lost. :)

That increases the risk of conflicts and, because of multiple trees we
have, the conflicts cause more work for us. Please don't take ANY
wireless patches to your tree (or any other tree for that matter) unless
Johannes or me has acked them.

If you don't get reply to your patch for few weeks (and the merge window
is not open), you can ping in the list or contact me.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
