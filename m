Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F310815F
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKXBr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:47:28 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33618 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKXBr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:47:28 -0500
Received: by mail-pf1-f195.google.com with SMTP id c184so5529553pfb.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 17:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3lBSw1FKqUY2XmkojjgeEVuCah7EC3Ab3ESxu/cmir0=;
        b=zWhzw7x5/RJn0C/Oqe6rYfQv+Tq3nuVMPxltU/b4lTxiuPAV9+ArjrPyt0+grcoqfE
         FkISyU4V763zqS2vAgr+htQCrDwW36gISid2swMb3mC9i+AAxE+wo5sgFixtWemSBjMa
         uz3ZtWRrdr43UC/iYbQE2nD9G9qloomONbdtHiEt+lIhII4JiuU/KUnGwiTUA7AgHEu9
         sp/+0/Bj9UrvsRAlrExekywwbCydKN41DniRk7lO4jEtlJZMfFqpXuxmcqI64hTuUkVh
         CmzXdZigAJR5OnVh6LyUaCrSDxy8UscxNHlWB7lqwxrEGhnfqoUTF08CHge0Q+LNd1k8
         S5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3lBSw1FKqUY2XmkojjgeEVuCah7EC3Ab3ESxu/cmir0=;
        b=HggXgMLwTsSYEChEPsktyc3YPn+0myOhqNCGsQWJXeqAnYyNGeiIBK2Zfi9t8Ix3uF
         wBKniV2kJ5mxxZi2TOK7LTO1HN+1VTkY3zX6RrFS3oIeIH3S1GAumKEMxDu1biPkmxPh
         USq7GbJX2Xayxg8e/PHdbQN5OAVMVc0Y6Awb9LEqateELFO8jy0mOQvlr7/sC71hA41e
         a9dFO3j4I07V/pHhZmXAL8MMxQbSFp4Ckf2S913xmDoy37Z2Uj82i6zQ5QqFYs4wPWVm
         picbxrGaTvNIa0QYr8Fs1zHbAe9xDD4VSJcqZRWQ6jLfUBP6i88JugiKV0P9Ab0UAgdD
         weVw==
X-Gm-Message-State: APjAAAWzd1ZoDF3gKHXYz05zWL2xGKw+QJOyrcJui9QR0txdb7UhKN+i
        spTHPgV+qXFwrcgK2NMzhDWb4Q==
X-Google-Smtp-Source: APXvYqyapDqAsl68Vz328TZMT25DsQ4nZ9A7WrUonPi+D/3NoDxQYj1dG4ceBc5wvJk9zMsuRtjKuQ==
X-Received: by 2002:a62:5485:: with SMTP id i127mr18879698pfb.186.1574560048001;
        Sat, 23 Nov 2019 17:47:28 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id c84sm3042658pfc.112.2019.11.23.17.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 17:47:27 -0800 (PST)
Date:   Sat, 23 Nov 2019 17:47:23 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com
Subject: Re: [PATCH net 4/4] ibmvnic: Serialize device queries
Message-ID: <20191123174723.2a5d603d@cakuba.netronome.com>
In-Reply-To: <1574451706-19058-5-git-send-email-tlfalcon@linux.ibm.com>
References: <1574451706-19058-1-git-send-email-tlfalcon@linux.ibm.com>
        <1574451706-19058-5-git-send-email-tlfalcon@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 13:41:46 -0600, Thomas Falcon wrote:
> @@ -5050,6 +5090,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  			  __ibmvnic_delayed_reset);
>  	INIT_LIST_HEAD(&adapter->rwi_list);
>  	spin_lock_init(&adapter->rwi_lock);
> +	mutex_init(&adapter->fw_lock);
>  	init_completion(&adapter->init_done);
>  	init_completion(&adapter->fw_done);
>  	init_completion(&adapter->reset_done);

Could you also add a mutex_destroy() call?
