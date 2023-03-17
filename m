Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FA56BEDF9
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCQQWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQQWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:22:02 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC81A6782A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:22:01 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id ay8so3716492wmb.1
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679070120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WK9yNSRVMlEjJBHOwhJwHBFPa8SNWqT9uE9ABk62B2U=;
        b=DG/fto1x98uQ7dSsGetIjYJWDexNDd5i4LfyYi7NUiz/WSFew62SHnWLIBzbeuVYJA
         PTxVBfS1gAOEUEiymezfy1LtBiNhWQOav3DpLy6ja3+l8BNlAJtDisQteOWEKOL/033d
         El5MmsPw4Of/YpfYhjCD52HU4YVV/Emc57hGz11Lkmwe/ttLSF5IYTlqkxYby+p5A7KE
         J6ZMSBeAVQSMC+5CH+jugzxU9DC9Bm01if+a2T2Rn72sjm/AuCE3jjzMpOqSWC74SJk9
         hHuE3ZUuCkm548uyPlOxaNNc+RMfCf+DkSFe2q/m5SSxooUZIDIxjXz6U8W6uJFmICCL
         txOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WK9yNSRVMlEjJBHOwhJwHBFPa8SNWqT9uE9ABk62B2U=;
        b=13tJnPrZh3hL587boZuUMWt6hLv3RCbjaMMmEHk45vkGCfhc/ExnylVHXmAsWtl4yv
         kDl0SxY96Rvq6x4HXsDLdmtdOPGhGiSfg0GGFl0EwGS5/E9jYYsYHnEVyk0D93xe2kBP
         BeHkamu7u79eTKgY3j+KblpP/LbHdXM0VC2zdDYpPUjAyxkzeXik3q5emNhF14192hOG
         Wynqb8vXPya+K6g8GxAKqB3ZKLxZuyOOHltQfVQSiAGsntwdaG6ArpZYrDVMrQ4xDsdW
         nGCn+13IPMgJ1RDZsY2YaZKFOuBi25QFZjF1uT4Y4M7D0lD4XeARYIEMUtSrdq6hbQ4Y
         ooIw==
X-Gm-Message-State: AO0yUKWBWWZqgj8Y8qNiJ4Q/h6VG4Aelc83pZui3x1xjVFIBxd3ZV+Zf
        Ks8D5LKNj9Hs/rmkEXv81IFelg==
X-Google-Smtp-Source: AK7set8HoNwwA1+/Xl56688DC6BYt9rhtjCtl5fanZOEjjmCrJBpY85I6piUWRSAGVEqRLFCTdji7w==
X-Received: by 2002:a05:600c:1546:b0:3ed:22f2:554c with SMTP id f6-20020a05600c154600b003ed22f2554cmr18431844wmg.29.1679070120483;
        Fri, 17 Mar 2023 09:22:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q8-20020a1cf308000000b003ed4f6c6234sm2408743wmq.23.2023.03.17.09.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 09:21:59 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:21:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBSTpoN6BOn5264a@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
>+{
>+	struct nlattr *hdr, *nest;
>+	struct dpll_device *dpll;
>+	unsigned long i;
>+	int ret;
>+
>+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
>+			  &dpll_nl_family, 0, DPLL_CMD_DEVICE_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	xa_for_each_marked(&dpll_device_xa, i, dpll, DPLL_REGISTERED) {
>+		nest = nla_nest_start(skb, DPLL_A_DEVICE);
>+		ret = dpll_msg_add_dev_handle(skb, dpll);
>+		if (ret) {
>+			nla_nest_cancel(skb, nest);
>+			break;
>+		}

Please fillup the attrs for the object. The format should be exactly the
same as for doit.


>+		nla_nest_end(skb, nest);
>+	}
>+	if (ret)
>+		genlmsg_cancel(skb, hdr);
>+	else
>+		genlmsg_end(skb, hdr);
>+
>+	return ret;
>+}
>+

[...]
