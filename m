Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8659DC4A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbfH0EGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:06:33 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40481 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfH0EGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 00:06:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so13205354pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 21:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JBsjBlq9bzoqe5LMxLSV0FG6rCf31vTjZTAlAh64M+E=;
        b=L2bNMgDeujIJtBkjpnHIPRN+ABIKlsQHbmyUELimXki3T8LzsT25Wd1wo2kkEUPS03
         AnG7hbwdMaH/zTR7vfqQY08Pmv8SCa2nLgf3Y3LQMvWCMZ4oKGYu/6JGH8Wya8I53sEN
         CFNsGw66UuqIc/QOWAmNcLq480W/B8HQE4MDvDChaYrUxnipqFbPBCRB45B4pVChRp7Z
         Q0BEKvaYHlIg87bxq8OjNvx9fVIkRpk7slEpvAU0YbIGvVBGRJRITCT/NHUZuFT62vr0
         gMs6cJxCPAnWBE9vqK70+2i8KgXgLx4X69zCmW+eqL/g3WXj/SQgYWTuy4GuznnmgX9m
         WIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JBsjBlq9bzoqe5LMxLSV0FG6rCf31vTjZTAlAh64M+E=;
        b=p6BK5tLHNvvkHsizcA/Muad5eGcEUylIgWk9AQICeKTTKiU3uW4q9ntvWpYl5WQm01
         m8iozj+PQCMj9h07YLHBRwI3aiZFmYu++woGLN91TGfKusvSJIpwoYLe705A9DJMqRe1
         x9iVMrLXN+gPDvnbwKu8eiGAA23e539RO67CROhhgVdN22/I/n5YdfaRcHE5Pl73vWou
         AxGUWlEnJ8KXouuhKW7JhsFDx1+wD2UgPRfkLcAbKhhwx+hVBhgBMuR9scIWKsVuiyQ1
         Lxz6S0DvxSKrN1JI9P4ZHwAp05lml3wLPvwCVeUeOC6dI5k1s5nbsDaf82HwdstceahP
         p4ew==
X-Gm-Message-State: APjAAAVunkZkg7rwYOCROtkF7TqTR62ccSZo4+o4SkhbJhutvN4rrnX0
        U6rECn6ZJ1gn7xSSXZRjHELVLhqWZSE=
X-Google-Smtp-Source: APXvYqy7Z0sqtW+edCa6+YuY8rmau27t04XM+CfZShBDuOlYO61Nfh7PUE7+lqYWYhJdAWomD0Ziqg==
X-Received: by 2002:a63:ea50:: with SMTP id l16mr19869802pgk.160.1566878792402;
        Mon, 26 Aug 2019 21:06:32 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id g36sm13503784pgb.78.2019.08.26.21.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 21:06:32 -0700 (PDT)
Date:   Mon, 26 Aug 2019 21:06:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
Message-ID: <20190826210615.6ce3631e@cakuba.netronome.com>
In-Reply-To: <20190826213339.56909-2-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
        <20190826213339.56909-2-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 14:33:22 -0700, Shannon Nelson wrote:
> +struct ionic {
> +	struct pci_dev *pdev;
> +	struct device *dev;
> +	struct devlink *dl;

No need for the dl pointer here. priv_to_devlink can be used to obtain
the devlink pointer based on priv structure address.

> +};
