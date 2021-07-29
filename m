Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E0A3DA11F
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbhG2Keb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:34:31 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:35095 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232054AbhG2Ke3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:34:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BF350580CD8;
        Thu, 29 Jul 2021 06:34:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 29 Jul 2021 06:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rZVUw9pgoUdhW+JWJZ3Hk75t5pQ
        SA6lpVEQ51FpxcxI=; b=Q27O/Jk/qRHVQGN6GeFY+jRt2URH60oKQYPW/A5hIkk
        mjQEJMTLuiKPDUwNoxKheQ4tX4IBrL9HBjOf8A2DUkLmuL4TEqk8ivC72/Q06jN3
        eE9f0NaUtcqnosZLQVLtcxneRxfn4iAJM95DiPHgmrqMAz2scB8VtdyT1ijSUNQC
        JUPRcr1tDBVACDz7cNCRalJCFIWK0g0akcGKInArTJD86nYIYjlBjX6+7IfTCW9a
        25GVIfidIbP6KVgoAsUUsWGoxMz0cE4sbnAv3cXQeCl/Qwjw/56ddwSyyEUctpXA
        dG3XjSqIY+eHZmN8RwWZEQ/wEhmdz0PV0uv4xu7oQbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rZVUw9
        pgoUdhW+JWJZ3Hk75t5pQSA6lpVEQ51FpxcxI=; b=V1c69sO71JXrJpZlvn/kDd
        2kSL2ND06sF4SdtQKX0hpYQ3TorQn/1dIIQJkfY0ZJl3ibr2LZ+QrIhUvVERJCfJ
        9BPOV8FxiSpgCsS3ck1OR9cqdjnxxODq+4NQlbDKQlqV3ma0pwpVUHBVqYOyiaT5
        zrYBpHaW0rMZkBgKzgGHpzK7wkIbrhNCJY/EGiRFYc0+CGBuN98ePs3qe8OXdTIB
        vAmxWVXJ61003OMYlTpyQus9UPdhkh7DQ7JesL35wazvyHjVAf88nYfsfz0MjM2Y
        1w/yfzHOvrdHciPUhFI4Enm3UygRNjJQpb7yEh3YHtDTPi0J5W0Wt3GjDclsxxbQ
        ==
X-ME-Sender: <xms:MYQCYTwUs5t13gEbuWaW2ydmCBCYzp1K7G0duvYUQNrFTQSueKLPqw>
    <xme:MYQCYbShsyZFgX8c0Y4Gzag6awCW9Q8WmwA-BNO3AiBQjIghHBp9HmAfdi1FKpkgt
    kQ3SnFln1GgjA>
X-ME-Received: <xmr:MYQCYdXpE_-Q5v-eY_ci5--tHpR734sQ3SYizU7JjEyvpC_EQ8KC6dDSIQBIv3CdRbe313Z2xdW7Hrhx_e2b6t0zNNoYtu61>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrhedugddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdortd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpedvfeeggeehudevuedvffdvtdevffeukedvheduuefhveegue
    dvhfetveduheejffenucffohhmrghinhepsghsshdrnhgvthenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MYQCYdhZzwriJ1isIAdiN-xrP4pgHYbJRYxOeMWp1_TBZOk31nCuZQ>
    <xmx:MYQCYVAVZUQaN3GkbKzfzxkaZN3Yu0hff7PSPnhMyE7NN-688JRiaQ>
    <xmx:MYQCYWKP1nb-Sfr2D-Txg4-mKd0_XgVot4ZjJwpYTR4Fb61h4-3o1w>
    <xmx:MoQCYdaaT1JR38lvWKFbniN8ojnxOke75PwZ3wrYsEmLdmP-jp8hbA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jul 2021 06:34:25 -0400 (EDT)
Date:   Thu, 29 Jul 2021 12:34:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Nguyen Dinh Phi <phind.uet@gmail.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH V2] cfg80211: Fix possible memory leak in function
 cfg80211_bss_update
Message-ID: <YQKELjKuAQsjmpLY@kroah.com>
References: <20210628132334.851095-1-phind.uet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628132334.851095-1-phind.uet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 09:23:34PM +0800, Nguyen Dinh Phi wrote:
> When we exceed the limit of BSS entries, this function will free the
> new entry, however, at this time, it is the last door to access the
> inputed ies, so these ies will be unreferenced objects and cause memory
> leak.
> Therefore we should free its ies before deallocating the new entry, beside
> of dropping it from hidden_list.
> 
> Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
> ---
> V2:	- Add subsystem to the subject line.
> 	- Use bss_ref_put function for better clean-up dynamically allocated
> 	cfg80211_internal_bss objects. It helps to clean relative hidden_bss.
> 
>  net/wireless/scan.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index f03c7ac8e184..7897b1478c3c 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -1754,16 +1754,14 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
>  			 * be grouped with this beacon for updates ...
>  			 */
>  			if (!cfg80211_combine_bsses(rdev, new)) {
> -				kfree(new);
> +				bss_ref_put(rdev, new);
>  				goto drop;
>  			}
>  		}
> 
>  		if (rdev->bss_entries >= bss_entries_limit &&
>  		    !cfg80211_bss_expire_oldest(rdev)) {
> -			if (!list_empty(&new->hidden_list))
> -				list_del(&new->hidden_list);
> -			kfree(new);
> +			bss_ref_put(rdev, new);
>  			goto drop;
>  		}
> 
> --
> 2.25.1

Did this change get lost somewhere?

thanks,

greg k-h
