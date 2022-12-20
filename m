Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1EE652198
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiLTNer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiLTNeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:34:46 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBAF18B1A
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:34:44 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 385163200912;
        Tue, 20 Dec 2022 08:34:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 20 Dec 2022 08:34:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671543281; x=1671629681; bh=P5kC81balsgGf9/oorLdwVsiLaI8
        EcpPlmO8igcM4+U=; b=Es7BPpBK0aW9SIFSKWlkHcuUJbunnXyIu+eSY30VcMJk
        yxIfUnaYF3X7Tb5FTb67Mrp0vumf1GT3pDetJ1mMwWq1L4zCU1FhN4th8i9ioaof
        e5g4K/wvuO6BhSgN0f0GrXekOlUgpmzDDz9UJKmsOziWsuKT3KqpX7Llt/cL8JUl
        zFv0X8+wlni27OB0esLYyosI6SuKp0fioiAEnIBU738jD6QOTktNFtwLgOr2wL68
        LH80SqMrjPIcNpWhy2vzamYylUTeLLhR56/m5BMWAludjj+MN+8hCTe7ZaJsj4KY
        vfPTBLM0gZoBW18Y3Bii+NNsr5gU86KegoJ1y7kcCw==
X-ME-Sender: <xms:8bmhY2x3QRqU_ulnh0KV7h98BOEunH02N_it5Zgwrfv9Zx5yg4zb5g>
    <xme:8bmhYyT9sAYO4bRf4hgaOGBLRBxCr9pS6MwPPmmPi1G-bjH3E8hcmas7Y82EFoXlS
    BJBAtaIR8Vddec>
X-ME-Received: <xmr:8bmhY4V4WmlBRpWn-UGV2xDuO3yaOz6DtIQadk9Qbcp13JU2H_cLS2JXd-0vV9Zgn-c5IzHU8Jp_N3T5Ic0psBnqRGk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeeigddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:8bmhY8g6TNkyzGBvD0wH3oNpFzMPWajEWnZR8dpaAGXghNu24YTxTg>
    <xmx:8bmhY4B76N7LxAkrUKLj2TQyssrk1JN58Iqn9zoV13kZa-_Z1Dk_jQ>
    <xmx:8bmhY9Ix2CKCle1qFhX-KsCs3FnFghVxKVdoV_W5J6d24Ye8bY8zQg>
    <xmx:8bmhY87tZPCxVeMFdh4cTLi-NhJj__gLKNzMEkOYSMdtS1RRciMsmg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Dec 2022 08:34:40 -0500 (EST)
Date:   Tue, 20 Dec 2022 15:34:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hao Lan <lanhao@huawei.com>
Cc:     lipeng321@huawei.com, shenjian15@huawei.com,
        huangguangbin2@huawei.com, chenjunxin1@huawei.com,
        netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com
Subject: Re: [PATCH iproute2] dcb: unblock mnl_socket_recvfrom if not message
 received
Message-ID: <Y6G57PG6hQh1SvlX@shredder>
References: <20221019012008.11322-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019012008.11322-1-lanhao@huawei.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 09:20:08AM +0800, Hao Lan wrote:
> From: Junxin Chen <chenjunxin1@huawei.com>
> 
> Currently, the dcb command sinks to the kernel through the netlink
> to obtain information. However, if the kernel fails to obtain infor-
> mation or is not processed, the dcb command is suspended.
> 
> For example, if we don't implement dcbnl_ops->ieee_getpfc in the
> kernel, the command "dcb pfc show dev eth1" will be stuck and subsequent
> commands cannot be executed.
> 
> This patch adds the NLM_F_ACK flag to the netlink in mnlu_msg_prepare
> to ensure that the kernel responds to user requests.

The analysis is not correct: The kernel does reply, but the reply does not
contain the 'DCB_ATTR_IEEE_PFC' attribute, causing the dcb utility to block on
recvmsg(). Since you changed the utility to request an ACK you need to make
sure this ACK is processed before issuing another request. Please test the
following patch. I would like to post it tomorrow.

Thanks

commit 7b545308a2273a7fd26204688fa632ec1b4c0205
Author: Ido Schimmel <idosch@nvidia.com>
Date:   Tue Dec 20 14:27:46 2022 +0200

    dcb: Do not leave ACKs in socket receive buffer
    
    Originally, the dcb utility only stopped receiving messages from a
    socket when it found the attribute it was looking for. Cited commit
    changed that, so that the utility will also stop when seeing an ACK
    (NLMSG_ERROR message), by setting the NLM_F_ACK flag on requests.
    
    This is problematic because it means a successful request will leave an
    ACK in the socket receive buffer, causing the next request to bail
    before reading its response.
    
    Fix that by not stopping when finding the required attribute in a
    response. Instead, stop on the subsequent ACK.
    
    Fixes: 84c036972659 ("dcb: unblock mnl_socket_recvfrom if not message received")
    Signed-off-by: Ido Schimmel <idosch@nvidia.com>

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 3ffa91d64d0d..9b996abac529 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -72,7 +72,7 @@ static int dcb_get_attribute_attr_ieee_cb(const struct nlattr *attr, void *data)
 
 	ga->payload = mnl_attr_get_payload(attr);
 	ga->payload_len = mnl_attr_get_payload_len(attr);
-	return MNL_CB_STOP;
+	return MNL_CB_OK;
 }
 
 static int dcb_get_attribute_attr_cb(const struct nlattr *attr, void *data)
@@ -126,7 +126,7 @@ static int dcb_set_attribute_attr_cb(const struct nlattr *attr, void *data)
 		return MNL_CB_ERROR;
 	}
 
-	return MNL_CB_STOP;
+	return MNL_CB_OK;
 }
 
 static int dcb_set_attribute_cb(const struct nlmsghdr *nlh, void *data)
