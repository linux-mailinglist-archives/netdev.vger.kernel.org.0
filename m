Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A253ED081
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhHPIpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:45:01 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60906
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234815AbhHPIo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:44:57 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id C105440CB9
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 08:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629103465;
        bh=5StmAxU2AOXbMFwiDpPqrKskutFIhD3O+XG8RAcrhBg=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=TA+w4IMxzCDLuGA/hn4++tLW2aPec4847ZmBFXxnQzviYwn793xvyh/6zvhk58toL
         J6SP9XGmhWcae/RptuNrjGdVVvx5mgMQqnq3VJHbOb0cVUPTQgBmM5VBJap4r3X3H6
         /W3rUADJZ4awjYNVmhIJc3zHpbp5Dn5n9t8EWiiw1FdIzzRwfWPLKxAThi3sD4E1ok
         /nnr3Krtk3uqAW8HU4pRB9Pn+YSczM7cJjsORBItrWQ76QrlvVBlC0KBefnbqBkvtZ
         L5VtuD+qZL9aJx6cLd4crnHML8QF+Sql7LXZ7uNDXOXH/EKcTjWoNOH5hxyVHIoPhG
         kfritkA85N/Yg==
Received: by mail-ed1-f72.google.com with SMTP id di3-20020a056402318300b003bebf0828a2so4440302edb.8
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 01:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5StmAxU2AOXbMFwiDpPqrKskutFIhD3O+XG8RAcrhBg=;
        b=CR/r6kmSKwh34UOsEmXQ1EGERbA+NfIt6raER2Otc1FNiJU1u0QLlHztLYId6wFX/Z
         UEfc4wbrTWe4OYVXpkHX47p2oXKFR0vBjjQHXXVbUrMKorgi87of1PPmD/k04YuQFpm5
         sVcEfy4qeyB9xyHmq+8O+53GVuDhVwFv1Yf8EGdJyGjRKYdOasCbmoM4uDxE8oeaZIj/
         OKy7XGosCkU3ibEOLpkSmrcmrgcvdDufv5XuksvkIL/h7fgI8mdefDbIBbW3wVwEfB/f
         /4GRzFE0xvoJdT9GKuNQlyh73O2ZVNM+oVT6BGGZdSHHla8b2cviyczHSvyr5yLBjKGJ
         tNLg==
X-Gm-Message-State: AOAM532e0eoOUxCgvToV0/cMYk103o91kjSLzQZ+gPmHt+XsMNb/7igR
        3M8tlUf0tR28D8n5IrAYMHhbmXhHNiG+a5wDf2bnw61/5Mfp169l79Dk5PuxLmVFBpMlS1+iJkO
        JKHiZVH9htK+KXxunjTwQie8SzJzHwFQ+oQ==
X-Received: by 2002:a17:906:f92:: with SMTP id q18mr15333214ejj.353.1629103465540;
        Mon, 16 Aug 2021 01:44:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgeOXTEbn8aiOBmH3TKWTTRbMArJhDuNlbv9uJlS3vN7PMhwqxt4mtlcHh4p0wRjmT14zz4w==
X-Received: by 2002:a17:906:f92:: with SMTP id q18mr15333200ejj.353.1629103465362;
        Mon, 16 Aug 2021 01:44:25 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.42.198])
        by smtp.gmail.com with ESMTPSA id i11sm4469870edu.97.2021.08.16.01.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 01:44:25 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] selftests: Add the NCI testcase reading T4T
 Tag
To:     bongsu.jeon2@gmail.com, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
References: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
 <20210816040600.175813-4-bongsu.jeon2@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <44581a43-daff-b05e-ee5a-45969ccb3d8c@canonical.com>
Date:   Mon, 16 Aug 2021 10:44:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816040600.175813-4-bongsu.jeon2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2021 06:06, bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Add the NCI testcase reading T4T Tag that has NFC TEST plain text.
> the virtual device application acts as T4T Tag in this testcase.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  tools/testing/selftests/nci/nci_dev.c | 384 +++++++++++++++++++++++---
>  1 file changed, 345 insertions(+), 39 deletions(-)
> 
> diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> index 34e76c7fa1fe..65d887dc5ccc 100644
> --- a/tools/testing/selftests/nci/nci_dev.c
> +++ b/tools/testing/selftests/nci/nci_dev.c
> @@ -57,6 +57,29 @@ const __u8 nci_init_rsp_v2[] = {0x40, 0x01, 0x1c, 0x00, 0x1a, 0x7e, 0x06,
>  const __u8 nci_rf_disc_map_rsp[] = {0x41, 0x00, 0x01, 0x00};
>  const __u8 nci_rf_disc_rsp[] = {0x41, 0x03, 0x01, 0x00};
>  const __u8 nci_rf_deact_rsp[] = {0x41, 0x06, 0x01, 0x00};
> +const __u8 nci_rf_deact_ntf[] = {0x61, 0x06, 0x02, 0x00, 0x00};
> +const __u8 nci_rf_activate_ntf[] = {0x61, 0x05, 0x1D, 0x01, 0x02, 0x04, 0x00,
> +				     0xFF, 0xFF, 0x0C, 0x44, 0x03, 0x07, 0x04,
> +				     0x62, 0x26, 0x11, 0x80, 0x1D, 0x80, 0x01,
> +				     0x20, 0x00, 0x00, 0x00, 0x06, 0x05, 0x75,
> +				     0x77, 0x81, 0x02, 0x80};
> +const __u8 nci_t4t_select_cmd[] = {0x00, 0x00, 0x0C, 0x00, 0xA4, 0x04, 0x00,
> +				    0x07, 0xD2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01};
> +const __u8 nci_t4t_select_cmd2[] = {0x00, 0x00, 0x07, 0x00, 0xA4, 0x00, 0x0C, 0x02,
> +				     0xE1, 0x03};
> +const __u8 nci_t4t_select_cmd3[] = {0x00, 0x00, 0x07, 0x00, 0xA4, 0x00, 0x0C, 0x02,
> +				     0xE1, 0x04};
> +const __u8 nci_t4t_read_cmd[] = {0x00, 0x00, 0x05, 0x00, 0xB0, 0x00, 0x00, 0x0F};
> +const __u8 nci_t4t_read_rsp[] = {0x00, 0x00, 0x11, 0x00, 0x0F, 0x20, 0x00, 0x3B,
> +				  0x00, 0x34, 0x04, 0x06, 0xE1, 0x04, 0x08, 0x00,
> +				  0x00, 0x00, 0x90, 0x00};
> +const __u8 nci_t4t_read_cmd2[] = {0x00, 0x00, 0x05, 0x00, 0xB0, 0x00, 0x00, 0x02};
> +const __u8 nci_t4t_read_rsp2[] = {0x00, 0x00, 0x04, 0x00, 0x0F, 0x90, 0x00};
> +const __u8 nci_t4t_read_cmd3[] = {0x00, 0x00, 0x05, 0x00, 0xB0, 0x00, 0x02, 0x0F};
> +const __u8 nci_t4t_read_rsp3[] = {0x00, 0x00, 0x11, 0xD1, 0x01, 0x0B, 0x54, 0x02,
> +				   0x65, 0x6E, 0x4E, 0x46, 0x43, 0x20, 0x54, 0x45,
> +				   0x53, 0x54, 0x90, 0x00};
> +const __u8 nci_t4t_rsp_ok[] = {0x00, 0x00, 0x02, 0x90, 0x00};
>  
>  struct msgtemplate {
>  	struct nlmsghdr n;
> @@ -87,7 +110,7 @@ static int create_nl_socket(void)
>  
>  static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
>  			   __u8 genl_cmd, int nla_num, __u16 nla_type[],
> -			   void *nla_data[], int nla_len[])
> +			   void *nla_data[], int nla_len[], __u16 flags)
>  {
>  	struct sockaddr_nl nladdr;
>  	struct msgtemplate msg;
> @@ -98,7 +121,7 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
>  
>  	msg.n.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
>  	msg.n.nlmsg_type = nlmsg_type;
> -	msg.n.nlmsg_flags = NLM_F_REQUEST;
> +	msg.n.nlmsg_flags = flags;
>  	msg.n.nlmsg_seq = 0;
>  	msg.n.nlmsg_pid = nlmsg_pid;
>  	msg.g.cmd = genl_cmd;
> @@ -108,12 +131,12 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
>  	for (cnt = 0; cnt < nla_num; cnt++) {
>  		na = (struct nlattr *)(GENLMSG_DATA(&msg) + prv_len);
>  		na->nla_type = nla_type[cnt];
> -		na->nla_len = nla_len[cnt] + NLA_HDRLEN;
> +		na->nla_len = NLMSG_ALIGN(nla_len[cnt] + NLA_HDRLEN);
>  
>  		if (nla_len > 0)
>  			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
>  
> -		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
> +		msg.n.nlmsg_len += na->nla_len;
>  		prv_len = na->nla_len;
>  	}
>  
> @@ -146,11 +169,11 @@ static int send_get_nfc_family(int sd, __u32 pid)
>  	nla_get_family_data = family_name;
>  
>  	return send_cmd_mt_nla(sd, GENL_ID_CTRL, pid, CTRL_CMD_GETFAMILY,
> -				1, &nla_get_family_type,
> -				&nla_get_family_data, &nla_get_family_len);
> +				1, &nla_get_family_type, &nla_get_family_data,
> +				&nla_get_family_len, NLM_F_REQUEST);
>  }
>  
> -static int get_family_id(int sd, __u32 pid)
> +static int get_family_id(int sd, __u32 pid, __u32 *event_group)
>  {
>  	struct {
>  		struct nlmsghdr n;
> @@ -158,8 +181,9 @@ static int get_family_id(int sd, __u32 pid)
>  		char buf[512];
>  	} ans;
>  	struct nlattr *na;
> -	int rep_len;
> +	int resp_len;

Here and in other places - all these renames rep_len->resp_len do not
look like related to the commit, so please split these to separate commit.
>  	__u16 id;
> +	int len;
>  	int rc;
>  
>  	rc = send_get_nfc_family(sd, pid);
> @@ -167,17 +191,49 @@ static int get_family_id(int sd, __u32 pid)
>  	if (rc < 0)
>  		return 0;
>  
> -	rep_len = recv(sd, &ans, sizeof(ans), 0);
> +	resp_len = recv(sd, &ans, sizeof(ans), 0);
>  
> -	if (ans.n.nlmsg_type == NLMSG_ERROR || rep_len < 0 ||
> -	    !NLMSG_OK(&ans.n, rep_len))
> +	if (ans.n.nlmsg_type == NLMSG_ERROR || resp_len < 0 ||
> +	    !NLMSG_OK(&ans.n, resp_len))
>  		return 0;
>  
> +	len = 0;
> +	resp_len = GENLMSG_PAYLOAD(&ans.n);
>  	na = (struct nlattr *)GENLMSG_DATA(&ans);
> -	na = (struct nlattr *)((char *)na + NLA_ALIGN(na->nla_len));
> -	if (na->nla_type == CTRL_ATTR_FAMILY_ID)
> -		id = *(__u16 *)NLA_DATA(na);
>  
> +	while (len < resp_len) {
> +		len += NLA_ALIGN(na->nla_len);
> +		if (na->nla_type == CTRL_ATTR_FAMILY_ID) {
> +			id = *(__u16 *)NLA_DATA(na);
> +		} else if (na->nla_type == CTRL_ATTR_MCAST_GROUPS) {
> +			struct nlattr *nested_na;
> +			struct nlattr *group_na;
> +			int group_attr_len;
> +			int group_attr;
> +
> +			nested_na = (struct nlattr *)((char *)na + NLA_HDRLEN);
> +			group_na = (struct nlattr *)((char *)nested_na + NLA_HDRLEN);
> +			group_attr_len = 0;
> +
> +			for (group_attr = CTRL_ATTR_MCAST_GRP_UNSPEC;
> +				group_attr < CTRL_ATTR_MCAST_GRP_MAX; group_attr++) {
> +				if (group_na->nla_type == CTRL_ATTR_MCAST_GRP_ID) {
> +					*event_group = *(__u32 *)((char *)group_na +
> +								  NLA_HDRLEN);
> +					break;
> +				}
> +
> +				group_attr_len += NLA_ALIGN(group_na->nla_len) +
> +						  NLA_HDRLEN;
> +				if (group_attr_len >= nested_na->nla_len)
> +					break;
> +
> +				group_na = (struct nlattr *)((char *)group_na +
> +							     NLA_ALIGN(group_na->nla_len));
> +			}
> +		}
> +		na = (struct nlattr *)(GENLMSG_DATA(&ans) + len);
> +	}
>  	return id;
>  }
>  
> @@ -189,12 +245,13 @@ static int send_cmd_with_idx(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
>  	int nla_len = 4;
>  
>  	return send_cmd_mt_nla(sd, nlmsg_type, nlmsg_pid, genl_cmd, 1,
> -				&nla_type, &nla_data, &nla_len);
> +				&nla_type, &nla_data, &nla_len, NLM_F_REQUEST);
>  }
>  
> -static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id, struct msgtemplate *msg)
> +static int get_nci_devid(int sd, __u16 fid, __u32 pid, int dev_id,
> +			 struct msgtemplate *msg)

Does not look related.

Best regards,
Krzysztof
