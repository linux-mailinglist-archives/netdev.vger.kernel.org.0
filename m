Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF2C6E6C2D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjDRSf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjDRSf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:35:26 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE59D301;
        Tue, 18 Apr 2023 11:35:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b73203e0aso10806935b3a.1;
        Tue, 18 Apr 2023 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681842907; x=1684434907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+LkTvhTOXVJ1s/XuxAodTCn49+ye6FDPI1LEp8TzFyM=;
        b=ExMh+q7GfkXnLKv7xHYL4ueZu9lbA3rANpmVebt1wn6KFsfREyYAiTy+nIwtz5yHOI
         OqKgj1aChzkJ5I50NVVUdOYAzUD8Fe54llrBdLcKeCffr1C2UdlbaYkTTM3msqZ9bhm7
         oA1hcczQRawE2pgfa1rrtiIjRr9QYEfIztchnkFP2d9ZIR++Vm7fkbg2X8pBf7j+W4n5
         Mmf1DICdtWmv10x9JLYmhtj/JaRAM3zyVHXxpfBFxZri1PzOTMiZYKYju+nWEdCt4mvj
         r3BGr7064Cq3NUXatnw3hQfE5TmbpF7LZu7U6ag4Ydduytpn03jrr6qSNl+dD3T2aBC+
         zuQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681842907; x=1684434907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LkTvhTOXVJ1s/XuxAodTCn49+ye6FDPI1LEp8TzFyM=;
        b=QxYZE2RXd7WMnfvpzGUIabIp3dInyAMtnjP3q/LvrkOSGMunU6m2flQK61vlaYnf9g
         HUngFdtp96rzYEVAIdoHAK2R7B5HiHsq12ObSoACltpDFwQpziPr8TpU9WMKwt4ERBoJ
         6eftySzxOUVBJ+Atqi8YmM7W2OsZUCW2Vj+P4L98yBfXwAw8Ln43IASzyPSW+hdlJEzW
         5xZW5D8MztuhPKlugUFVAsgyGindj9dclFq+xZsZfQE07Z2kiBXTNLCg6lay11TB4P+t
         Y1tojsYA1Mva6KyNwbPz579EEon9Lfff+vKwUIHKPHAbU9htra2+Dz1lnvSPrI3+eebI
         KNCw==
X-Gm-Message-State: AAQBX9cp1QrrnLo5Ob0P0AEBa54IzOVmTuQDVdG8L0OGTJ2zJjJcvx/R
        NGJbinjRjae7BQyuh0uLtAJpYWy9Gac=
X-Google-Smtp-Source: AKy350b6/4oIoJpjf5siFWAARrFs6ZOw41D6oD4lSEqRzBX4RgXFfZdzEbBrAvEA4dsE1YYp6g2PbA==
X-Received: by 2002:a17:90a:9f05:b0:247:1131:dcd2 with SMTP id n5-20020a17090a9f0500b002471131dcd2mr422862pjp.23.1681842907191;
        Tue, 18 Apr 2023 11:35:07 -0700 (PDT)
Received: from MacBook-Pro-6.local.dhcp.thefacebook.com ([2620:10d:c090:500::4:4cf1])
        by smtp.gmail.com with ESMTPSA id gl13-20020a17090b120d00b0024781f5e8besm4451623pjb.26.2023.04.18.11.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 11:35:06 -0700 (PDT)
Date:   Tue, 18 Apr 2023 11:35:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v3 1/6] bpf: add bpf_link support for
 BPF_NETFILTER programs
Message-ID: <20230418183504.cxa3wdfxs2yx4cqo@MacBook-Pro-6.local.dhcp.thefacebook.com>
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418131038.18054-2-fw@strlen.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 03:10:33PM +0200, Florian Westphal wrote:
> @@ -1560,6 +1562,13 @@ union bpf_attr {
>  				 */
>  				__u64		cookie;
>  			} tracing;
> +			struct {
> +				__u32		pf;
> +				__u32		hooknum;
> +				__s32		prio;
> +				__u32		flags;
> +				__u64		reserved[2];
> +			} netfilter;
>  		};
>  	} link_create;
>  
> @@ -6410,6 +6419,12 @@ struct bpf_link_info {
>  		struct {
>  			__u32 map_id;
>  		} struct_ops;
> +		struct {
> +			__u32 pf;
> +			__u32 hooknum;
> +			__s32 priority;
> +			__u32 flags;
> +		} netfilter;
>  	};
>  } __attribute__((aligned(8)));
...
> +int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	struct bpf_link_primer link_primer;
> +	struct bpf_nf_link *link;
> +	int err;
> +
> +	if (attr->link_create.flags)
> +		return -EINVAL;
> +
> +	if (attr->link_create.netfilter.reserved[0] | attr->link_create.netfilter.reserved[1])
> +		return -EINVAL;

Why add 'reserved' name that we cannot change later?
I think 'flags' is enough.

> +	link->hook_ops.pf = attr->link_create.netfilter.pf;
> +	link->hook_ops.priority = attr->link_create.netfilter.prio;

let's use the same name in both cases ? Either prio or priority. Both sound fine.

> +	link->hook_ops.hooknum = attr->link_create.netfilter.hooknum;
