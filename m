Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183EDB7160
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfISCEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:04:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387630AbfISCEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 22:04:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82EBE611CE; Thu, 19 Sep 2019 02:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568858676;
        bh=mFV2vEP/8mA/QxmcsiAkCPqpsqaXlPi9eR1iPn0M8fQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iUvclgyc8BpaPdU0PvT4P6fal6QjeXJbzA2lmi+30OiBAcEHGzpKfkRLEShmbUrEz
         DMi1TTacaE2MH+MVGxWA3GH1ETYBx9xIRSWUm8zhjjy4o2ybyK0pjgkCC62mx2/OjI
         oiNjpAepffm9ii9azanL50lUBXtH6uWpdj9IE6GI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D94156034D;
        Thu, 19 Sep 2019 02:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568858658;
        bh=mFV2vEP/8mA/QxmcsiAkCPqpsqaXlPi9eR1iPn0M8fQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nyn3A7FyPAKjqgVytJi0vxRklnn3QcAioTQCBGVZg+Jn2Ltiyiop1yTgth09oNrRQ
         AUyS0IE/eqarULDfbOGaoX6+9IH8sXjzsZLyWE3kb/dafWOttmBPsF7AD1CcgetL+L
         Em8aqzsk6nmgWKp/7gyOt2h6tvBlCOYMLVA9k5uI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Sep 2019 20:04:18 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 2/5] net: Add NETIF_F_GRO_LIST feature
In-Reply-To: <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <20190918072517.16037-3-steffen.klassert@secunet.com>
 <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
Message-ID: <8bc2e1658e74963d6c3ff297acdcbce6@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-18 10:10, Willem de Bruijn wrote:
> On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
>> 
>> This adds a new NETIF_F_GRO_LIST feature flag. I will be used
>> to configure listfyed GRO what will be implemented with some
>> followup paches.
> 
> This should probably simultaneously introduce SKB_GSO_FRAGLIST as well
> as a BUILD_BUG_ON in net_gso_ok.
> 
> Please also in the commit describe the constraints of skbs that have
> this type. If I'm not mistaken, an skb with either gso_size linear
> data or one gso_sized frag, followed by a frag_list of the same. With
> the exception of the last frag_list member, whose mss may be less than
> gso_size. This will help when reasoning about all the types of skbs we
> may see at segmentation, as we recently had to do [1]
> 

Would it be preferrable to allow any size skbs for the listification.
Since the original skbs are being restored, single gso_size shoudln't
be a constraint here.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
