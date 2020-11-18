Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD22B73F7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgKRBzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRBzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:55:13 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2A2C061A48;
        Tue, 17 Nov 2020 17:55:12 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t21so110433pgl.3;
        Tue, 17 Nov 2020 17:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q4ld5mlmqDWI4DEWyP3Rx7wUM6TJ1InnwVci+pJQfek=;
        b=TMRfqD73dTn04ObWkQ5m0km2voh0EUCDN5fscI0L0ZoZ88nAi/ZzFhF6zYYledDcRI
         RGFdGZsowbMWCHufbtlGnCFTD3Sy0uK/9OutpFIN+TLwZSqr4an5Thjj/5RKuyAl3sBD
         gKoBH+UeM07/+r6CjnXcxxgAR456JhxixhLtrK0n28YDRcOOCji0c31Re6pbGHU0Gmjy
         IrQN4d0b+d7hyrmu/hypedn65SMhLPjbpblEFgPan3vDqrcF+M8GecPSuZd88nrpzQYs
         qv1uHNyVriAdST+WlsKexxwDQagFRz6k+lckFNcaJvOpV7Rd7RjcVFCKf+sRbqsfXN1W
         lpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q4ld5mlmqDWI4DEWyP3Rx7wUM6TJ1InnwVci+pJQfek=;
        b=HMfclGBH7jZr46jGEyvnxu+2OvsGjuehVosJ9yeBCfp+fsEZfx2n9Cm0PJTIz59/Me
         VVrDWLqiCQamK4FClwn2oplHsl5hpl33sHccT9jAVoiHDSnyaJU78aBEnwDWEZCavJSw
         qfJu+ic2ILaMKD3DnNeS1fXEkBrAHggnooEq4+Bo+6EZmdKes7+3DF64WKiHBEGF2TCD
         fn2GbZl3qkGz46EsmIyVcRVE5OvIbFFvvjBuC5FCyPAHmzxAH4w0EXHcJ3kKYdE54XVq
         sMuV6nqZ1m045uAcC+rjtXdDM6YD2s/1GfjpfBMMlxFJHNx9NwkZgflP/nm/EU3XNnRq
         SB1Q==
X-Gm-Message-State: AOAM532OJOKjoc4aKc8C9zAJbcmTpM8Y5oojd1IK8VKGXMTAFBolR/3D
        EPiYLWDvIuOEkam5NS1uztU=
X-Google-Smtp-Source: ABdhPJwQmWb3n8nUN1VZjGvaYqOR46yI2VbJ3gVSKChUwxgliLRWB6eX31qHm84R0Mhpiu039tk1/g==
X-Received: by 2002:a63:1d16:: with SMTP id d22mr6145566pgd.335.1605664512289;
        Tue, 17 Nov 2020 17:55:12 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91 (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id l133sm23220891pfd.112.2020.11.17.17.55.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Nov 2020 17:55:11 -0800 (PST)
Date:   Tue, 17 Nov 2020 17:55:04 -0800
From:   Tao Ren <rentao.bupt@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jean Delvare <jdelvare@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: Re: [PATCH 1/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring
 driver
Message-ID: <20201118015503.GA5636@taoren-ubuntu-R90MNF91>
References: <20201117010944.28457-1-rentao.bupt@gmail.com>
 <20201117010944.28457-2-rentao.bupt@gmail.com>
 <20201117051352.GA208504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117051352.GA208504@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guenter,

Thanks for pointing out these problems. I'm working on the comments and
will send out v2 soon.


Cheers,

Tao

On Mon, Nov 16, 2020 at 09:13:52PM -0800, Guenter Roeck wrote:
> On Mon, Nov 16, 2020 at 05:09:43PM -0800, rentao.bupt@gmail.com wrote:
> > From: Tao Ren <rentao.bupt@gmail.com>
> > 
> > Add hardware monitoring driver for the Maxim MAX127 chip.
> > 
> > MAX127 min/max range handling code is inspired by the max197 driver.
> > 
> > Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
> > ---
> >  drivers/hwmon/Kconfig  |   9 ++
> >  drivers/hwmon/Makefile |   1 +
> >  drivers/hwmon/max127.c | 286 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 296 insertions(+)
> >  create mode 100644 drivers/hwmon/max127.c
> > 
> > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> > index 9d600e0c5584..716df51edc87 100644
> > --- a/drivers/hwmon/Kconfig
> > +++ b/drivers/hwmon/Kconfig
> > @@ -950,6 +950,15 @@ config SENSORS_MAX1111
> >  	  This driver can also be built as a module. If so, the module
> >  	  will be called max1111.
> >  
> > +config SENSORS_MAX127
> > +	tristate "Maxim MAX127 12-bit 8-channel Data Acquisition System"
> > +	depends on I2C
> > +	help
> > +	  Say y here to support Maxim's MAX127 DAS chips.
> > +
> > +	  This driver can also be built as a module. If so, the module
> > +	  will be called max127.
> > +
> >  config SENSORS_MAX16065
> >  	tristate "Maxim MAX16065 System Manager and compatibles"
> >  	depends on I2C
> > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> > index 1083bbfac779..01ca5d3fbad4 100644
> > --- a/drivers/hwmon/Makefile
> > +++ b/drivers/hwmon/Makefile
> > @@ -127,6 +127,7 @@ obj-$(CONFIG_SENSORS_LTC4260)	+= ltc4260.o
> >  obj-$(CONFIG_SENSORS_LTC4261)	+= ltc4261.o
> >  obj-$(CONFIG_SENSORS_LTQ_CPUTEMP) += ltq-cputemp.o
> >  obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
> > +obj-$(CONFIG_SENSORS_MAX127)	+= max127.o
> >  obj-$(CONFIG_SENSORS_MAX16065)	+= max16065.o
> >  obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
> >  obj-$(CONFIG_SENSORS_MAX1668)	+= max1668.o
> > diff --git a/drivers/hwmon/max127.c b/drivers/hwmon/max127.c
> > new file mode 100644
> > index 000000000000..df74a95bcf28
> > --- /dev/null
> > +++ b/drivers/hwmon/max127.c
> > @@ -0,0 +1,286 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Hardware monitoring driver for MAX127.
> > + *
> > + * Copyright (c) 2020 Facebook Inc.
> > + */
> > +
> > +#include <linux/err.h>
> > +#include <linux/hwmon.h>
> > +#include <linux/hwmon-sysfs.h>
> > +#include <linux/i2c.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/sysfs.h>
> > +
> > +/* MAX127 Control Byte. */
> > +#define MAX127_CTRL_START	BIT(7)
> > +#define MAX127_CTRL_SEL_OFFSET	4
> 
> That would better be named _SHIFT.
> 
> > +#define MAX127_CTRL_RNG		BIT(3)
> > +#define MAX127_CTRL_BIP		BIT(2)
> > +#define MAX127_CTRL_PD1		BIT(1)
> > +#define MAX127_CTRL_PD0		BIT(0)
> > +
> > +#define MAX127_NUM_CHANNELS	8
> > +#define MAX127_SET_CHANNEL(ch)	(((ch) & 7) << (MAX127_CTRL_SEL_OFFSET))
> 
> () around MAX127_CTRL_SEL_OFFSET is unnecessary.
> 
> > +
> > +#define MAX127_INPUT_LIMIT	10	/* 10V */
> > +
> > +/*
> > + * MAX127 returns 2 bytes at read:
> > + *   - the first byte contains data[11:4].
> > + *   - the second byte contains data[3:0] (MSB) and 4 dummy 0s (LSB).
> > + */
> > +#define MAX127_DATA1_SHIFT	4
> > +
> > +struct max127_data {
> > +	struct mutex lock;
> > +	struct i2c_client *client;
> > +	int input_limit;
> > +	u8 ctrl_byte[MAX127_NUM_CHANNELS];
> > +};
> > +
> > +static int max127_select_channel(struct max127_data *data, int channel)
> > +{
> > +	int status;
> > +	struct i2c_client *client = data->client;
> > +	struct i2c_msg msg = {
> > +		.addr = client->addr,
> > +		.flags = 0,
> > +		.len = 1,
> > +		.buf = &data->ctrl_byte[channel],
> > +	};
> > +
> > +	status = i2c_transfer(client->adapter, &msg, 1);
> > +	if (status != 1)
> > +		return status;
> > +
> 
> Other drivers assume that this function can return 0. Please
> take that into account as well.
> 
> > +	return 0;
> > +}
> > +
> > +static int max127_read_channel(struct max127_data *data, int channel, u16 *vin)
> > +{
> > +	int status;
> > +	u8 i2c_data[2];
> > +	struct i2c_client *client = data->client;
> > +	struct i2c_msg msg = {
> > +		.addr = client->addr,
> > +		.flags = I2C_M_RD,
> > +		.len = 2,
> > +		.buf = i2c_data,
> > +	};
> > +
> > +	status = i2c_transfer(client->adapter, &msg, 1);
> > +	if (status != 1)
> > +		return status;
> 
> Same as above.
> 
> > +
> > +	*vin = ((i2c_data[0] << 8) | i2c_data[1]) >> MAX127_DATA1_SHIFT;
> 
> THis seems wrong. D4..D11 end up in but 8..15, and D0..D3 end up in bit
> 0..3. Seems to me the upper byte should be left shifted 4 bit.
> The result then needs to be scaled to mV (see below).
> 
> Also, for consistency I would suggest to either use () for both
> parts of the logical or operation or for none.
> 
> > +	return 0;
> > +}
> > +
> > +static ssize_t max127_input_show(struct device *dev,
> > +				 struct device_attribute *dev_attr,
> > +				 char *buf)
> > +{
> > +	u16 vin;
> > +	int status;
> > +	struct max127_data *data = dev_get_drvdata(dev);
> > +	struct sensor_device_attribute *attr = to_sensor_dev_attr(dev_attr);
> > +
> > +	if (mutex_lock_interruptible(&data->lock))
> > +		return -ERESTARTSYS;
> 
> I don't think the _interruptible is warranted in this driver.
> 
> > +
> > +	status = max127_select_channel(data, attr->index);
> > +	if (status)
> > +		goto exit;
> > +
> > +	status = max127_read_channel(data, attr->index, &vin);
> > +	if (status)
> > +		goto exit;
> > +
> > +	status = sprintf(buf, "%u", vin);
> 
> This is not correct. The ABI expects values in milli-Volt, and per datasheet
> the values need to be scaled depending on polarity and range settings (see
> table 3 in datasheet). Also, if the range includes negative numbers,
> the reported voltage can obviously be negative. That means %u (and u16)
> can not be correct. "Transfer Function" in the datasheet describes how to
> convert/scale the received data.
> 
> > +
> > +exit:
> > +	mutex_unlock(&data->lock);
> > +	return status;
> > +}
> > +
> > +static ssize_t max127_range_show(struct device *dev,
> > +				 struct device_attribute *dev_attr,
> > +				 char *buf)
> > +{
> > +	u8 ctrl, rng_bip;
> > +	struct max127_data *data = dev_get_drvdata(dev);
> > +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(dev_attr);
> > +	int rng_type = attr->nr;	/* 0 for min, 1 for max */
> > +	int channel = attr->index;
> > +	int full = data->input_limit;
> > +	int half = full / 2;
> > +	int range_table[4][2] = {
> > +		[0] = {0, half},	/* RNG=0, BIP=0 */
> > +		[1] = {-half, half},	/* RNG=0, BIP=1 */
> > +		[2] = {0, full},	/* RNG=1, BIP=0 */
> > +		[3] = {-full, full},	/* RNG=1, BIP=1 */
> > +	};
> 
> This can be a static const table. The variables 'full' and 'half'
> are effectively constants and not really needed.
> 
> > +
> > +	if (mutex_lock_interruptible(&data->lock))
> > +		return -ERESTARTSYS;
> > +	ctrl = data->ctrl_byte[channel];
> > +	mutex_unlock(&data->lock);
> 
> This lock is only needed because "ctrl" is written piece by piece.
> I would suggest to rewrite the store function to write ctrl atomically.
> Then the lock here is no longer needed.
> 
> > +
> > +	rng_bip = (ctrl >> 2) & 3;
> > +	return sprintf(buf, "%d", range_table[rng_bip][rng_type]);
> > +}
> > +
> > +static void max127_set_range(struct max127_data *data, int channel)
> > +{
> > +	data->ctrl_byte[channel] |= MAX127_CTRL_RNG;
> > +}
> > +
> > +static void max127_clear_range(struct max127_data *data, int channel)
> > +{
> > +	data->ctrl_byte[channel] &= ~MAX127_CTRL_RNG;
> > +}
> > +
> > +static void max127_set_polarity(struct max127_data *data, int channel)
> > +{
> > +	data->ctrl_byte[channel] |= MAX127_CTRL_BIP;
> > +}
> > +
> > +static void max127_clear_polarity(struct max127_data *data, int channel)
> > +{
> > +	data->ctrl_byte[channel] &= ~MAX127_CTRL_BIP;
> > +}
> > +
> > +static ssize_t max127_range_store(struct device *dev,
> > +				  struct device_attribute *devattr,
> > +				  const char *buf,
> > +				  size_t count)
> > +{
> > +	struct max127_data *data = dev_get_drvdata(dev);
> > +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> > +	int rng_type = attr->nr;	/* 0 for min, 1 for max */
> > +	int channel = attr->index;
> > +	int full = data->input_limit;
> > +	int half = full / 2;
> > +	long input, output;
> > +
> > +	if (kstrtol(buf, 0, &input))
> > +		return -EINVAL;
> > +
> > +	if (rng_type == 0) {	/* min input */
> > +		if (input <= -full)
> > +			output = -full;
> > +		else if (input < 0)
> > +			output = -half;
> > +		else
> > +			output = 0;
> > +	} else {		/* max input */
> > +		output = (input >= full) ? full : half;
> > +	}
> > +
> 
> With the _info API, I would suggest to separate min and max functions.
> This would both simplify the code and make it easier to read and
> review. 
> 
> > +	if (mutex_lock_interruptible(&data->lock))
> > +		return -ERESTARTSYS;
> 
> This should be rewritten to update "ctrl" in one step.
> Something like
> 
> 	u8 ctrl;
> 	...
> 	ctrl = data->ctrl_byte[channel];
> 	if (output == -MAX127_INPUT_LIMIT)
> 		ctrl |= MAX127_CTRL_RNG | MAX127_CTRL_BIP;
> 	else if (output == -half)
> 		ctrl |= MAX127_CTRL_BIP;
> 		ctrl &= ~MAX127_CTRL_RNG;
> 	else if (output == 0)
> 		ctrl &= ~MAX127_CTRL_BIP;
> 	else lf (output == half)
> 		ctrl &= ~MAX127_CTRL_RNG;
> 	else
> 		ctrl |= MAX127_CTRL_RNG;
> 
> 	data->ctrl_byte[channel] = ctrl;
> 
> I would suggest to separate the min and max functions, though.
> 
> > +
> > +	if (output == -full) {
> > +		max127_set_polarity(data, channel);
> > +		max127_set_range(data, channel);
> > +	} else if (output == -half) {
> > +		max127_set_polarity(data, channel);
> > +		max127_clear_range(data, channel);
> > +	} else if (output == 0) {
> > +		max127_clear_polarity(data, channel);
> > +	} else if (output == half) {
> > +		max127_clear_range(data, channel);
> > +	} else {
> > +		max127_set_range(data, channel);
> > +	}
> > +
> > +	mutex_unlock(&data->lock);
> > +
> > +	return count;
> > +}
> > +
> > +#define MAX127_SENSOR_DEV_ATTR_DEF(ch)					   \
> > +	static SENSOR_DEVICE_ATTR_RO(in##ch##_input, max127_input, ch);	   \
> > +	static SENSOR_DEVICE_ATTR_2_RW(in##ch##_min, max127_range, 0, ch); \
> > +	static SENSOR_DEVICE_ATTR_2_RW(in##ch##_max, max127_range, 1, ch)
> > +
> > +MAX127_SENSOR_DEV_ATTR_DEF(0);
> > +MAX127_SENSOR_DEV_ATTR_DEF(1);
> > +MAX127_SENSOR_DEV_ATTR_DEF(2);
> > +MAX127_SENSOR_DEV_ATTR_DEF(3);
> > +MAX127_SENSOR_DEV_ATTR_DEF(4);
> > +MAX127_SENSOR_DEV_ATTR_DEF(5);
> > +MAX127_SENSOR_DEV_ATTR_DEF(6);
> > +MAX127_SENSOR_DEV_ATTR_DEF(7);
> > +
> > +#define MAX127_SENSOR_DEVICE_ATTR(ch)			\
> > +	&sensor_dev_attr_in##ch##_input.dev_attr.attr,	\
> > +	&sensor_dev_attr_in##ch##_min.dev_attr.attr,	\
> > +	&sensor_dev_attr_in##ch##_max.dev_attr.attr
> > +
> > +static struct attribute *max127_attrs[] = {
> > +	MAX127_SENSOR_DEVICE_ATTR(0),
> > +	MAX127_SENSOR_DEVICE_ATTR(1),
> > +	MAX127_SENSOR_DEVICE_ATTR(2),
> > +	MAX127_SENSOR_DEVICE_ATTR(3),
> > +	MAX127_SENSOR_DEVICE_ATTR(4),
> > +	MAX127_SENSOR_DEVICE_ATTR(5),
> > +	MAX127_SENSOR_DEVICE_ATTR(6),
> > +	MAX127_SENSOR_DEVICE_ATTR(7),
> > +	NULL,
> > +};
> > +
> > +ATTRIBUTE_GROUPS(max127);
> > +
> > +static const struct attribute_group max127_attr_groups = {
> > +	.attrs = max127_attrs,
> > +};
> > +
> > +static int max127_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *id)
> > +{
> > +	int i;
> > +	struct device *hwmon_dev;
> > +	struct max127_data *data;
> > +	struct device *dev = &client->dev;
> > +
> > +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	data->client = client;
> > +	mutex_init(&data->lock);
> > +	data->input_limit = MAX127_INPUT_LIMIT;
> 
> What is the point of input_limit ? It is never modified.
> Why not use MAX127_INPUT_LIMIT directly where needed ?
> 
> > +	for (i = 0; i < ARRAY_SIZE(data->ctrl_byte); i++)
> > +		data->ctrl_byte[i] = (MAX127_CTRL_START |
> > +				      MAX127_SET_CHANNEL(i));
> > +
> > +	hwmon_dev = devm_hwmon_device_register_with_groups(dev,
> > +				client->name, data, max127_groups);
> 
> Please use the devm_hwmon_device_register_with_info() API.
> 
> Thanks,
> Guenter
> 
> > +
> > +	return PTR_ERR_OR_ZERO(hwmon_dev);
> > +}
> > +
> > +static const struct i2c_device_id max127_id[] = {
> > +	{ "max127", 0 },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, max127_id);
> > +
> > +static struct i2c_driver max127_driver = {
> > +	.class		= I2C_CLASS_HWMON,
> > +	.driver = {
> > +		.name	= "max127",
> > +	},
> > +	.probe		= max127_probe,
> > +	.id_table	= max127_id,
> > +};
> > +
> > +module_i2c_driver(max127_driver);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Mike Choi <mikechoi@fb.com>");
> > +MODULE_AUTHOR("Tao Ren <rentao.bupt@gmail.com>");
> > +MODULE_DESCRIPTION("MAX127 Hardware Monitoring driver");
> > -- 
> > 2.17.1
> > 
