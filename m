Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D488C1B90B4
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgDZNp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:45:58 -0400
Received: from mout.web.de ([212.227.15.4]:55533 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDZNp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 09:45:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587908745;
        bh=5W3b2E7k21ZMiqMvB1KOtLfzNi5N75REcK7+gb02gX8=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=Ec6Ezo7avK9humZh5lhiNUnAjStzh5lwOWOVqN7L//ztNhuVH7qIlsH4LkwJ9UNVA
         kRiUHrQY0gN/rQ0eY2e6tB3Hg9JGDdtg2vj0SX80ZtpwTWcRK0pe0cPvmscSVY3qgJ
         ciwASOg0ikWl9jZmjyYOhdiZwo+HL2V4OugN11KY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.52.156]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lcxfc-1ikbMH0S92-00iCYy; Sun, 26
 Apr 2020 15:45:45 +0200
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Chris Lew <clew@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Siddartha Mohanadoss <smohanad@codeaurora.org>
Subject: Re: [PATCH v2 2/3] net: qrtr: Add MHI transport layer
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <85591553-f1f2-a7c9-9c5a-58f74ebeaf38@web.de>
Date:   Sun, 26 Apr 2020 15:45:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hto1Oe3KMF6Kn2QN25fgiQmcX5MG3/poqV5HXZ2jMTIUTyxQiAB
 01h21WniyZQ9WtX3+1r20BJ4M/Rg2ggp3OQZ0iPxLDyU+Pphyn3+3xF+is9E0msK0fFRoFE
 J3cuEiRfnMcwqT2+YhxLlliWCikynUPDOOjdxre+U6ZWunbAaoz7u/oZxUwmhiYaD7Grp1h
 vo0Q1AKichEah3p+hziTw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fb0qtxIs6Ms=:YHKnr7XW/87wD9cd9K/HTg
 P6QbfCkfZvuD4Bm0nV/xpj173rwzMycOC9YCwIY8Bzgqev+fTIW7YIOhRNEXGFx1cu0VtcH8v
 lZOw5qysrB7KlC3ARMWTaTKLfUuK7ao+JW35Quj2IjvkP19aS++yUyh9uaxuD9Q4qXsS+WPjd
 Yx/YtQ03CqpI3COoQfCXNgX6lknMuDR0MBdOechbiQ/cqXdWAhSVcNZue+4cQGAL7lYT2Uqnw
 yHjIiII8A+W7WQnIPtjKjnigBAkrARNAKh3p9/vQ0g/6sm43WhsqEDiClB99Z+P8b5i2Q5Pzt
 HyWzPlsfyTqxG7tEZHX6HJZ+vs/T9aoIyumtZjrx7gnulupJuBP3f+bf1vz2LKsXhjoyLOBib
 jxJxGGfS6fWIsgRSMtCRpjLKsIf0tCDcF6pl7M9L50HY0WbSC7wpOZSsVGfah979+j/YoVzp5
 BhWwIc3aVhzB0ZT1ONEzS+8WscDmHaOhsqw9mCXYs93TbpZo9YW4apMmf1gya/Ba90z26UHcY
 1C858lA0sfz5C5fzoaopnCBGaS93MmK2dF3Qf5P2uYCp5GHSYc68d8uoNcBef/G33W55tl6JX
 D0xo1SvUsBXc9UEd2u51P+XV6oja6fyKlXuBs64VWQPx29UtGnkxGqKsUf9jhBt3RXSkU5lKm
 pxg4lsIgnqdc4r1S8AF2I7ObhtwbUid3N5NC4tZ3vAlLsI0rY29gkZFbZFkE9KBxTzW4yP6r2
 CfyAzEEnVIETKMXjwz/nP82iXiKhPwmWTlFZS5iC7J8OIrAp0DDXbEAQqe2hrdSXAXTgKfUZe
 zfqVcML7mggF9ISAw3UormBUzGVGdK+DzrHBA//wWYyl5W/7xZ5pjv+wv9mkUhqIF8waCgiHs
 PRNfRx1bzuH9NkWTE5zz9m5FpADIQL/q1i3cViOsMOb6ELoTyXIEHa1OZ8kmnvM1s+9DCPWDA
 SNT/bYbdYKfFlFjiu7cQRVfuYv0c8+UtWkGFw+Iq5HqwtdtVjLYqUzWmLw3PuLS6QBMctLKht
 /g2XQVnFraJSVyXXa2oz1ACiE2p36rKfEO/tfbsdKANGMUuTnOOQfCQ8UgQrFlFiS+ERCj6vE
 vY62+KOKa2fSDaPeMgOPmNsOAxDrK7Mav4RT8mmfM7kX1h04z7l7n2UcfQU/k/ISu5T4AZ75c
 Zd9lxwc2ugI+e2Q79RiRn8KBpVU3l9LEX7/ZB0+3NBybWI6sSM6FkHMwNc4jkSHb7X24LWs6c
 SxLXFhUm+7rRI0YEB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hence, this commit adds MHI transport layer support to QRTR for
> transferring the QMI messages over IPC Router.

I suggest to reconsider software development consequences around
another implementation detail.


=E2=80=A6
> +static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff =
*skb)
> +{
=E2=80=A6
> +	rc =3D mhi_queue_skb(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
> +			   MHI_EOT);
> +	if (rc) {
> +		kfree_skb(skb);
> +		return rc;
> +	}
=E2=80=A6
> +}

I propose again to add a jump target so that a bit of exception handling c=
ode
can be better reused at the end of this function implementation.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3Db2768df24ec400dd4f7fa79542f797e9=
04812053#n450

+	if (rc)
+		goto free_skb;
=E2=80=A6
+	return rc;
+
+free_skb:
+	kfree_skb(skb);
+	return rc;
+}


Regards,
Markus
