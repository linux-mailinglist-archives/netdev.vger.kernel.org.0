Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0D510815E
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKXBrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:47:01 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39357 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKXBrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:47:01 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so2997789pga.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 17:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yMmdkZWPRNJJFij2NhsWbh6pUoNvkfx10Q4+z88ErM0=;
        b=UBeOhOVQGRUkz7+Ha9DMWP6dQXEuwXHgZnurqd+/0MrwsSGQWsqAJ0Cd0VOEzd8VQE
         zRlywA6Fc+Q3pJDm2ui0qc11p4S+uqx9+rJ4ttJBEnJl1aEfktMil0M+Msyhe/fJ5S9i
         nyIlVLjvk040Tpv6Nla7pRFQkSjBKQG7fC59zfrY8X2LUrnQcrb0BNrvJ1uf/S2rCMEq
         9SQ3iDhpMSMrF1wRmcuY1LYwh5D+wNZ5y4gGD8VhReAlzriVkKxPH27IIzHRiQuZjWV5
         PeSz52jdtL2LzlW6UGKUmLovrSjSuLLQgpdBgyubpMyt5GAN+hIAcD2Pp3YFYK0C1lAL
         Z8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yMmdkZWPRNJJFij2NhsWbh6pUoNvkfx10Q4+z88ErM0=;
        b=ODdQm5O6PwTFBSMn3m1r4VTmWy9x79D+U+PN/MJqSAnf2F7lLAeO8gY0bYqNpUwHPn
         JrQ7W/NLLrD9Zlvhf5b9GQHtiwtFtPyrfbGZaV2viSvxuDXuLMsxXjEbgywuRfO0IUTI
         b3lR/SMV/wCwCRzUOmSIWU4EPWt2szwB6rnaEL6lwUIgSSGP7odSbrX7FDEQFEEvjAbR
         4mvkc69q07MZbgKqS1qvv5ulMlRdgEhSF6Bwfgn3K/ETsAIAbvgb8qAjfHL9F90Xo3VJ
         iJrPtZpZI80ijkFmfPsQUxnTFBa0cVWsKgl9waYQAR2dH6w61pLnOAY9RfC9/BF8GNVX
         DwtA==
X-Gm-Message-State: APjAAAUzCaHOyw1pcrAe1Hbb2Tifj4kDqNoJbG6boi7XEtCZzW2Er7Nt
        T9ComKxCW61g+c80FD5hiotghQ==
X-Google-Smtp-Source: APXvYqxnDB6Vj5Fe6vlAlXy44XNkKayLVR9vUlTsn1u0ajlJlGnUZHsww4zNV01AT214QrfKB50gEQ==
X-Received: by 2002:a63:df09:: with SMTP id u9mr24303463pgg.20.1574560018915;
        Sat, 23 Nov 2019 17:46:58 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i5sm2920463pfo.52.2019.11.23.17.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 17:46:58 -0800 (PST)
Date:   Sat, 23 Nov 2019 17:46:53 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com
Subject: Re: [PATCH net 3/4] ibmvnic: Bound waits for device queries
Message-ID: <20191123174653.19e37c30@cakuba.netronome.com>
In-Reply-To: <1574451706-19058-4-git-send-email-tlfalcon@linux.ibm.com>
References: <1574451706-19058-1-git-send-email-tlfalcon@linux.ibm.com>
        <1574451706-19058-4-git-send-email-tlfalcon@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 13:41:45 -0600, Thomas Falcon wrote:
> +static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
> +				       struct completion *comp_done,
> +				       unsigned long timeout)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +	u8 retry = 5;
> +
> +restart_timer:
> +	if (!adapter->crq.active) {
> +		netdev_err(netdev, "Device down!\n");
> +		return -ENODEV;
> +	}
> +	/* periodically check that the device is up while waiting for
> +	 * a response
> +	 */
> +	if (!wait_for_completion_timeout(comp_done, timeout / retry)) {
> +		if (!adapter->crq.active) {
> +			netdev_err(netdev, "Device down!\n");
> +			return -ENODEV;
> +		} else {
> +			retry--;
> +			if (retry)
> +				goto restart_timer;
> +			netdev_err(netdev, "Operation timing out...\n");
> +			return -ETIMEDOUT;

Hm. This is not great. I don't see the need to open code a loop with
a goto:

while (true) {
	if (down())
		return E;

	if (retry--)
		break;

	if (wait())
		return 0
}

print(time out);
return E;

The wait_for_completion_timeout() will not be very precise, but I think
with 5 sleeps it shouldn't drift off too far from the desired 10sec.

> +		}
> +	}
> +
> +	return 0;
> +}
