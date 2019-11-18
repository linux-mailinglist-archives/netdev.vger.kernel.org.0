Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECB3100EBA
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfKRWVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 17:21:36 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43402 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRWVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 17:21:35 -0500
Received: by mail-lf1-f68.google.com with SMTP id l14so8515684lfh.10
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 14:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=k8tXvyojuzIpGqqZbdiFU+fQa+u+1+HqoxvD/bINmWw=;
        b=Wfm+A2UU5wPRDg1SMAD6R61AQ5XyyAcA+QYMX0gxvsq0xwoogOpUdq2vuhCw0RF1ms
         Vtl5xTF58LswzSMtdjNRgdKYQ5myagl5Cg+mpUKtsAbte6sm29VGozNtwra7ysUujc1r
         eRe34JI3RrFyEDetqkXzaGmAII12jYrHnsui/Z1jFpwPC7vmnb2Sd3gSD2Bi3gEFm/pE
         MehhKnZ6MbbGBxkdEjfJ9sAjoHmkQ/jOS1quGveC8iqwuxKdhl/mG72iXkCF0DlIv40M
         jrkTp7c0O6aZqQVPC+Pb7+bPI4ZwnNLd+ZGD6D8imsql97huDrYthu2GNcHYT/l0mY/f
         JbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=k8tXvyojuzIpGqqZbdiFU+fQa+u+1+HqoxvD/bINmWw=;
        b=bO8t56FGvWpZLmd0p7QQIAZuhF8cOuChmxz+AO84rN522VScz00aXu1py/aX6NbVkS
         iK92jlzAkgm11VqcWTMcGzPFJOFIVPfN+d4UFWS8ckTtkY6IqcPvy2tyLo1m8y1g8o1r
         qxOGuXPWyC7o+KUbNUypItiK0ZLCN4k3zYE8jL7h9orgDLIiT5JNA6JZspVaGjUtJ2NJ
         Pa48zTTGGKntCmMxxYolYi9w2BywMtTGg/jVf+POJGSWAqiyHcMHdcNfpr8hqwUzzi/B
         1slQOn83tpO+Nqqzt9voeiW+O8sLcAtwb/jerFg0BtluSJWW/k4EnVf/t+kA9Yv4JKW1
         kD/A==
X-Gm-Message-State: APjAAAW2ImGzryGgm4j2qLSWaUxJUzBKFTUyD7PpQtsORf6xLC5R59Qi
        9rLM2QS/j6dQvZyE9zKAKdb6Dg==
X-Google-Smtp-Source: APXvYqwL5R10R+su55IxhTubpVHRH7aFTPubqpCMTaOUvrhsWiPM/PDB5XrJGcB4hWmko9SmRrYqLA==
X-Received: by 2002:a05:6512:49c:: with SMTP id v28mr1197714lfq.9.1574115694006;
        Mon, 18 Nov 2019 14:21:34 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m18sm9528509ljg.3.2019.11.18.14.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 14:21:33 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:21:20 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: initialize ethtool info->fw_version
 before use
Message-ID: <20191118142120.2cec693d@cakuba.netronome.com>
In-Reply-To: <f40bcf8cd93677c12bca1f06e74385c9a5f49819.1574096873.git.jtoppins@redhat.com>
References: <f40bcf8cd93677c12bca1f06e74385c9a5f49819.1574096873.git.jtoppins@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 12:07:53 -0500, Jonathan Toppins wrote:
> If the info->fw_version has garbage in the buffer this can lead to a BUG()
> being generated in strlcat() due to the use of strlen(). Initialize the
> buffer before use.
> 
> The use of a systemtap script can demonstrate the problem by injecting
> garbage into fw_version:


> @@ -1111,6 +1111,8 @@ static void bnx2x_get_drvinfo(struct net_device *dev,
>  	int ext_dev_info_offset;
>  	u32 mbi;
>  
> +	info->fw_version[0] = 0;
> +
>  	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
>  	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));

I don't know systemtap, so it's very unclear what you're trying to fix
here. Setting random fields of info to 0 seems pointless as the entire
structure is zeroed before the call in ethtool_get_drvinfo().

Please explain.
