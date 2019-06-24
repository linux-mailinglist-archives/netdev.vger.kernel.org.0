Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837FE51D35
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfFXVkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:40:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33378 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfFXVkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:40:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id w40so5636154qtk.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=m5K7cZetcijY0fEJX5mutitQcqWRu/jY/9Bvg6ECf2M=;
        b=Uer0B0QCplKA+nnwbndA63xZv+UiV2tYSqMiSCap4oskQkndqun2paa/Qi9cgyj/61
         eR58eW7G+bha0NVU4XNZrFsml1cTUpxvXaIsmq/QzvD+Fn64hxkgqQDzmtaL2wsX5OK0
         VGq2JFcCQQ1nyLjIg5Ub7KZEC8eZDTQMjid4jCNlrj82wA1VM3fLj0RLDXTrepJQdH7x
         4ORur0CEnNCe89BR6MRNJ3ZBu0rHOIQfgRGpGYZaepW4pQ+Lg2D+JCdATYEDJ6YeL4c6
         2sUzOIa8QwuAL7SUq3xa2QtG5v8VZ9vbM9E7RJuniYKTb23hODIhgIEc9b1SZ37Q5sS6
         an+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=m5K7cZetcijY0fEJX5mutitQcqWRu/jY/9Bvg6ECf2M=;
        b=W37aIaxwcLr6BJOwjUwYUipiPfWsfFdOcWvGkQeqp5scHF8YolWw5T4/GFDFuyde0g
         6FdJ9lQnfbOTeWrDd/x8ayxKxzAM9uWtWs7DUDz3eIBGkVq/KMuYI2/MNTKctzCusqd8
         eh5Cd4wOkdfdciok+GkQq4A7uPqRP90U/GOeN+eK6DJBeAzjZXTACKyFjkqkv8MbfnZr
         zUy3Q2mIgucePWEYqUj+1Tjpa/dh2KZUhIxKiEPQ6MoLqtpK1WLcoLEFhQ727A0hQKCD
         ELAMT54IcZMNoQ6hNGQaKI6y1S5/c+tkpmypvVpg7x+L4LJrX7HcO4TDXMXL8oq/BxJ7
         HV6Q==
X-Gm-Message-State: APjAAAWFRvtt8xqXNUuG8ExOv4j/zyWXJE2LDhnpkn5xqJkdxUqxef/Q
        W8GowM1RuyzeF9/1TKe+dvlJHQ==
X-Google-Smtp-Source: APXvYqysWXsAhZyppdBhgBmck95xmjWLSHZ0JqoopBuTkLyKgpJru1LR6LNjqsdeCjE44Ua1NVsbmw==
X-Received: by 2002:ac8:29c9:: with SMTP id 9mr105765661qtt.196.1561412418866;
        Mon, 24 Jun 2019 14:40:18 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d38sm7311212qtb.95.2019.06.24.14.40.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 14:40:18 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:40:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, intel-wired-lan@lists.osuosl.org,
        vinicius.gomes@intel.com, l@dorileo.org, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com
Subject: Re: [PATCH net-next v5 2/7] etf: Add skip_sock_check
Message-ID: <20190624144013.3168dde2@cakuba.netronome.com>
In-Reply-To: <1561138108-12943-3-git-send-email-vedang.patel@intel.com>
References: <1561138108-12943-1-git-send-email-vedang.patel@intel.com>
        <1561138108-12943-3-git-send-email-vedang.patel@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jun 2019 10:28:23 -0700, Vedang Patel wrote:
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 8b2f993cbb77..409d1616472d 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -990,6 +990,7 @@ struct tc_etf_qopt {
>  	__u32 flags;
>  #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
>  #define TC_ETF_OFFLOAD_ON	BIT(1)
> +#define TC_ETF_SKIP_SOCK_CHECK	BIT(2)
>  };
>  
>  enum {

I think build bot complained about the code not building on 32bit.
When you respin could you include a patch to remove the uses of BIT()
in UAPI?  See: https://www.spinics.net/lists/netdev/msg579344.html
